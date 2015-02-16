
# taken from gplots pkg
col2hex <- function (cname) {
  colMat <- col2rgb(cname)
  rgb(red = colMat[1, ]/255, green = colMat[2, ]/255, blue = colMat[3,]/255)
}

# ripped/modified from ggthemes pkg
tableau_colors <- function(palette="tableau20") {

  x <- list(
      tableau20 =
        c("#1F77B4",
          "#AEC7E8",
          "#FF7F0E",
          "#FFBB78",
          "#2CA02C",
          "#98DF8A",
          "#D62728",
          "#FF9896",
          "#9467BD",
          "#C5B0D5",
          "#8C564B",
          "#C49C94",
          "#E377C2",
          "#F7B6D2",
          "#7F7F7F",
          "#C7C7C7",
          "#BCBD22",
          "#DBDB8D",
          "#17BECF",
          "#9EDAE5"),
      ## Tablau10 are odd, Tableau10-light are even
      tableau10medium =
        c("#729ECE",
          "#FF9E4A",
          "#67BF5C",
          "#ED665D",
          "#AD8BC9",
          "#A8786E",
          "#ED97CA",
          "#A2A2A2",
          "#CDCC5D",
          "#6DCCDA"),
      gray5 =
        c("#60636A",
          "#A5ACAF",
          "#414451",
          "#8F8782",
          "#CFCFCF"),
      colorblind10 =
        c("#006BA4",
          "#FF800E",
          "#ABABAB",
          "#595959",
          "#5F9ED1",
          "#C85200",
          "#898989",
          "#A2C8EC",
          "#FFBC79",
          "#CFCFCF"),
      trafficlight =
        c("#B10318",
          "#DBA13A",
          "#309343",
          "#D82526",
          "#FFC156",
          "#69B764",
          "#F26C64",
          "#FFDD71",
          "#9FCD99"),
      purplegray12 =
        c("#7B66D2",
          "#A699E8",
          "#DC5FBD",
          "#FFC0DA",
          "#5F5A41",
          "#B4B19B",
          "#995688",
          "#D898BA",
          "#AB6AD5",
          "#D098EE",
          "#8B7C6E",
          "#DBD4C5"),
      ## purplegray6 is oddd
      bluered12 =
        c("#2C69B0",
          "#B5C8E2",
          "#F02720",
          "#FFB6B0",
          "#AC613C",
          "#E9C39B",
          "#6BA3D6",
          "#B5DFFD",
          "#AC8763",
          "#DDC9B4",
          "#BD0A36",
          "#F4737A"),
      ## bluered6 is odd
      greenorange12 =
        c("#32A251",
          "#ACD98D",
          "#FF7F0F",
          "#FFB977",
          "#3CB7CC",
          "#98D9E4",
          "#B85A0D",
          "#FFD94A",
          "#39737C",
          "#86B4A9",
          "#82853B",
          "#CCC94D"),
      ## greenorange6 is odd
      cyclic =
        c("#1F83B4",
          "#1696AC",
          "#18A188",
          "#29A03C",
          "#54A338",
          "#82A93F",
          "#ADB828",
          "#D8BD35",
          "#FFBD4C",
          "#FFB022",
          "#FF9C0E",
          "#FF810E",
          "#E75727",
          "#D23E4E",
          "#C94D8C",
          "#C04AA7",
          "#B446B3",
          "#9658B1",
          "#8061B4",
          "#6F63BB")
    )

  return(x[[palette]])
}