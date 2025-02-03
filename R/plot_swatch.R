#' Plot a color swatch from hex
#'
#' @param palette A character vector with colors in hex
#' @param nrow Number of rows to display the palette in
#'
#' @return A ggplot object
#' @export
#'
#' @examples
#' x <- c("FF0000", "#00FFFF", "#0000FF")
#' plot_swatch(x)



plot_swatch <- function(palette, nrow = 1) {

  stopifnot(is.vector(palette))

  palette_df <- data.frame(hex = palette) |>
    mutate(id = row_number()) |>
    cbind(as.data.frame(colorspace::hex2RGB(palette)@coords))

  palette_df <- palette_df |>
    cbind(
      rgb2hsv(palette_df$R, palette_df$G, palette_df$B) |>
        t() |>
        as.data.frame()
    )  %>%
    mutate(across(.cols = R:B, ~ . * 255),
           across(.cols = h:v, \(x) round(x, 3)))

  palette_df$hex <- fct_inorder(palette_df$hex)
  palette_df |>
    ggplot(aes(xmin=0, xmax = 1, ymin = 0, ymax = 1, fill = hex)) +
    geom_rect() +
    geom_fit_text(aes(x = .5, y = .7, fill = hex, label = hex), contrast = TRUE, inherit.aes = FALSE, fontface = "bold") +
    geom_fit_text(aes(x = .5, y = .5,fill = hex, label = glue::glue("R: {palette_df$R} G: {palette_df$G} B: {palette_df$B}")), contrast = T, inherit.aes = F, fontface = "bold") +
    geom_fit_text(aes(x = .5, y = .3,fill = hex, label = glue::glue("H: {palette_df$h} S: {palette_df$s} V: {palette_df$v}")), contrast = T, inherit.aes = F, fontface = "bold") +
    scale_fill_identity() +
    facet_wrap(~hex, nrow = nrow) +
    coord_fixed() +
    theme_void() +
    theme(legend.position = "none",
          plot.background = element_rect(fill = NA, color = NA),
          strip.text = element_blank())
}

