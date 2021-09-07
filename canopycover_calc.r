#install.packages("magick")
library(magick)

psphere <- image_read('PineyIsland.jpg')
psphere_info <- image_info(psphere)
psphere_info

# calculate the crop dimensions and crop the upper half of the image
dim_crop <- paste0(psphere_info$width,"x",psphere_info$height/2)
psphere_crop <- image_crop(psphere, geometry=dim_crop, repage=TRUE)

#rescale the image to a square
psphere_scale <- image_sample(psphere_crop, geometry=paste0(psphere_info$width,"x",psphere_info$width,"!"))

# conver to polar coordinates
psphere_polar <- image_distort(psphere_scale, distortion = "polar", coordinates=c(0,0))

# create a circular mask 
polar_info <- image_info(psphere_polar)
ii_min <- min(polar_info$width, polar_info$height)

fig <- image_draw(image_blank(ii_min, ii_min)) # create a new image with white background and black circle
symbols(ii_min/2, ii_min/2, circles=(ii_min/2)-3, bg='black', inches=FALSE, add=TRUE)
dev.off()

psphere_polar <- image_composite(psphere_polar, fig, operator='copyopacity') # create an image composite using both images
psphere_polar <- image_background(psphere_polar, 'black') # set background as black
print(psphere_polar)

#write the output
image_write(psphere_polar, path = "psphere_polar.jpg", format = "jpg")



