#' Plot a color palette on color wheel
#'
#' @param palette A character vector with colors in hex
#'
#' @return A ggplot object
#' @export
#'
#' @import ggplot2
#' @import dplyr
#' @import colorspace
#' @import forcats
#' @import ggfittext
#' @import tidyr
#' @import glue
#' @importFrom grDevices rgb2hsv
## usethis namespace: end
#' @examples
#' x <- c("#FF0000", "#00FFFF", "#0000FF")
#' plot_wheel(x)


plot_wheel <- function(palette) {

  palette_df <- data.frame(hex = palette) |>
    dplyr::mutate(id = row_number()) |>
    cbind(
      as.data.frame(colorspace::hex2RGB(palette)@coords)) # Normalize to [0,1]

  palette_df <- palette_df |>
    cbind(
      rgb2hsv(palette_df$R, palette_df$G, palette_df$B) |>
        t() |>
        as.data.frame()
    )


  hue_values <- seq(0, 1, length.out = 360)  # 360 hue values
  color_data <- data.frame(
    xmin = hue_values,
    xmax = hue_values + (1/360),  # Small increment to create adjacent rectangles
    ymin = 1.1,  # Bottom of the rectangle
    ymax = 1.2,  # Top of the rectangle
    color = hsv(hue_values, 1, 1)  # Convert hue to colors
  )



  palette_df |>
    ggplot2::ggplot(aes(x = h, y = s, color = hex)) +
    geom_point(size = 7) +
    geom_rect(data = color_data, aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax, fill = color), inherit.aes = FALSE) +
    scale_fill_identity() +
    scale_color_identity() +
    scale_x_continuous(breaks = c(0,.1,.2,.3,.4,.5,.6,.7,.8,.9), expand = c(0,0)) +
    scale_y_continuous(limits = c(0, 1.2), expand = c(0,-.15)) +
    coord_polar(clip = "off") +
    theme_void() +
    theme(legend.position = "none",
          panel.grid.major = element_line(color = "grey80"))
}
