# Copyright © 2022 University of Kansas. All rights reserved.
#
# Creative Commons Attribution NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)

.get_timestamps <- function(raw, epoch, frequency, tz) {

  if("start_time" %in% names(attributes(raw))){
    start <-
      attr(raw, "start_time") %>%
      lubridate::force_tz(tz)
  } else {
    start <-
      raw[1, "time"] %>%
      lubridate::force_tz(tz)
  }

  end <- .last_complete_epoch(raw, epoch, frequency, tz)

  list(
    start = start,
    end = end,
    timestamps = seq(start, end, epoch)
  )

}


.last_complete_epoch <- function(raw, epoch, frequency, tz) {

  samples_per_epoch <- frequency * epoch

  utils::tail(raw$time, samples_per_epoch * 10) %>%
  lubridate::floor_date(paste(epoch, "sec")) %>%
  as.character(.) %>%
  rle(.) %>%
  {.$values[max(which(.$lengths == samples_per_epoch))]} %>%
  as.POSIXct(tz) %>%
  {. + epoch - 0.001} %>%
  lubridate::force_tz(tz)

}
