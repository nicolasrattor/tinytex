% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tlmgr.R
\name{tl_pkgs}
\alias{tl_pkgs}
\title{List the names of installed TeX Live packages}
\usage{
tl_pkgs(only_installed = TRUE)
}
\arguments{
\item{only_installed}{Whether to list installed packages only.}
}
\value{
A character vector of package names.
}
\description{
Calls \command{tlmgr info --list --data name} to obtain the names of all
(installed) TeX Live packages. Platform-specific strings in package names are
removed, e.g., \code{"tex"} is returned for the package
\pkg{tex.x86_64-darwin}.
}
