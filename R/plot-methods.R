#
# methods for plotting geographic-distance plots
#
###########################################################################################
#' Calculate and Plot Sample Distances by Geography/Ecological Distance
#'
#' Scatterplot generation of samples using geogrpahic and eoclogical distances
#'
#' @usage plot_distance(physeq, distancemethod="jaccard")
#'
#' @param physeq (Required). 
#'  The name of the phyloseq object. This must have sample data with Latitude and Longitude Columns.
#'  
#' @param distancemethod (Optional). Default \code{"jaccard"}.
#'  The name of an ecological distance method. See ?distance for more information
#'  
#' @import phyloseq
#' @importFrom reshape2 melt
#' @importFrom sp spDists
#' @export
#' @examples
#' data(batfecal)
#' plot_distance(batfecal)
plot_distance <- function(physeq, distancemethod="jaccard"){
    latlon <- .check_physeq(physeq)
    latcol <- as.character( latlon[1] )
    loncol <- as.character( latlon[2] )
    data   <- data.frame( sample_data(physeq) )
    data   <- .check_NA(data, latcol)
    data   <- .coerce_numeric(data,latcol)
    data   <- .check_NA(data, loncol)
    data   <- .coerce_numeric(data,loncol)
    names  <- names(data)
    
    #get bigcircle distances using spDists
    #spDists exlpects the first column to be longitude
    df2 <- data[ c(loncol, latcol) ]
    names(df2) <- c("lon", "lat")
    #df2$lat <- sapply(df2$lat, .degree_to_radian)
    #df2$lon <- sapply(df2$lon, .degree_to_radian)
    df2 <- as.matrix(df2)
    geodistances <- sp::spDists(df2, longlat=TRUE)
    colnames(geodistances) <- row.names(df2)
    row.names(geodistances) <- row.names(df2)
    geodistances <- .dist_to_edge_table(geodistances, dname = "geodist")
    
    #get ecologicaldistances
    ecodistance <- distance(physeq, method = distancemethod)
    ecodistance <- .dist_to_edge_table(ecodistance, dname="ecodist" )
    
    #make mergeable names for the two distance functions and merge
    concatvals <- function(x,y){ return(paste(x,"_",y,sep=""))}
    geodistances['pairs'] <- mapply(concatvals, geodistances$Var1, geodistances$Var2)
    ecodistance['pairs'] <- mapply(concatvals, ecodistance$Var1, ecodistance$Var2)
    df <- merge(geodistances, ecodistance, by="pairs")
    
    #make the plot
    p <- ggplot(df, aes(y = ecodist,x=geodist)) + 
         geom_point() +
         xlab("Km") + 
         ylab(distancemethod) +
         ggtitle(paste("Pairwise Sample Distance:", "Km vs.", distancemethod,"Distance.", sep=" "))
    
    return(p)
}