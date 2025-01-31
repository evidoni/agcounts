# Copyright © 2022 University of Kansas. All rights reserved.
#
# Creative Commons Attribution NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)

testthat::test_that("Check that data can be read into agcounts using each agread method", {

  file <- system.file("extdata/example.gt3x", package = "agcounts")

  expect_error(agread(path = file, parser = "no parser"))

  pygt3x <- agread(path = file, parser = "pygt3x", verbose = TRUE)
  expect_equal(nrow(pygt3x), 18000)
  expect_equal(ncol(pygt3x), 4)

  ggir <- agread(path = file, parser = "GGIR", verbose = TRUE)
  expect_equal(nrow(ggir), 18000)
  expect_equal(ncol(ggir), 4)

  rawData <- agread(path = file, parser = "read.gt3x", verbose = TRUE)
  expect_equal(nrow(rawData), 18000)
  expect_equal(ncol(rawData), 4)

  raw <- read.gt3x(path = file, asDataFrame = TRUE)
  sf <- .get_frequency(raw)
  agcalibrated <- agcalibrate(raw)
  expect_equal(nrow(agcalibrated), 18001) # Looks like agcalibrate produces 1 additional row of data
  expect_equal(ncol(agcalibrated), 4)

  class(raw) <- "data.frame"
  raw[91:180, c("X", "Y", "Z")] <- 0
  expect_error(agcalibrate(raw))

})
