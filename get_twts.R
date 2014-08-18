#' Loading tweets about F1, teams, drivers and others.
#'
#' This function is a wrapper which downloads F1 tweets.
#'
#' @param end_time time when the download shoud stop.
#'   A string standard POSIX format
#' @return A \code{data.frame} with the downloaded tweets
#' @note Download may stop after 15 minutes after the intended time
#'   as the result of download limits in the Twitter API
#'
#' @author András Tajti \email{atajti@@gmail.com}
#' @export
#' @examples get_F1_twts("2014-12-31")
#' @docType function


get_F1_tweets <- function(end_time="2014-12-31 23:59"){
  # getting tweets about #F1 and F1 pilots and teams


  # open API
  source("registerAPI.R")

  # set end time for crawlers:
  end_time <- as.POSIXlt(end_time)

  # teams, pilots:
  users <- list(
    users_teams <- c("Formula1", "F1", "F1official",
              # csapatok
              "McLarenF1", "redbullracing", "InsideFerrari", "MercedesAMGF1",
              "WilliamsRacing", "ToroRossoSpy", "clubforce", "Lotus_F1Team",
              "Marussia_F1Team", "CaterhamF1","OfficialSF1Team"),
    users_drivers1 <- c(           # versenyzők
              "JensonButton","KevinMagnussen", "danielricciardo",
              "alo_oficial", "LewisHamilton", "nico_rosberg",
              "MassaFelipe19", "ValtteriBottas", "JeanEricVergne", "Dany_Kvyat"),
    users_drivers2 <- c("NicoHulkenberg", "SChecoPerez", "Pastormaldo", "RGrosjean",
              "Jules_Bianchi", "maxchilton", "Ericsson_Marcus", "kamui_kobayashi",
              "EstebanGtz", "SutilAdrian"))



  # loading #F1 tweets:
  #====================

  # get some tweets
  f1_twts <- searchTwitter("#F1", n=100)#, CAInfo="cacert_0626.pem")

  # create a data.frame
  f1_twts_df <- twListToDF(f1_twts)
  # get the time of last tweet
  since_id <- f1_twts_df[1, "id"]

  # until end_time, append new tweets
  while(Sys.time() < end_time){

    # #F1 tweets
    f1_twts <- searchTwitter("#F1", sinceID=since_id)
    f1_twts_df <- rbind(f1_twts_df, twListToDF(f1_twts))
    # new since_id:
    since_id <- f1_twts_df[1, "id"]

    # collect users' timeline:
    for(i in users){
      twts <- unlist(sapply(i, function(usr)
        {userTimeline(usr, n=100,
                      includeRts=TRUE, sinceID=since_id)}))
      if(!is.null(twts)){
        f1_twts_df <- rbind(twListToDF(twts))
        } else {
          Sys.sleep(15*60)
        }
    }
  }

  # write results to a csv:
  filename <- paste0("F1twts_", end_time)
  write.csv(f1_twts_df, file=filename,
            row.names=FALSE)
  return(f1_twts_df)
}
