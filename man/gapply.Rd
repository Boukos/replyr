% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/groupedApply.R
\name{gapply}
\alias{gapply}
\title{grouped ordered apply}
\usage{
gapply(df, gcolumn, f, ..., ocolumn = NULL, decreasing = FALSE,
  partitionMethod = "split", bindrows = TRUE, maxgroups = 100,
  eagerCompute = FALSE)
}
\arguments{
\item{df}{remote dplyr data item}

\item{gcolumn}{grouping column}

\item{f}{transform function or pipleline}

\item{...}{force later values to be bound by name}

\item{ocolumn}{ordering column (optional)}

\item{decreasing}{if TRUE sort in decreasing order by ocolumn}

\item{partitionMethod}{method to partition the data, one of 'group_by' (depends on f being dplyr compatible), 'split' (only works over local data frames), or 'extract'}

\item{bindrows}{if TRUE bind the rows back into a data item, else return split list}

\item{maxgroups}{maximum number of groups to work over (intentionally not enforced if partitionMethod=='group_by')}

\item{eagerCompute}{if TRUE call compute on split results}
}
\value{
transformed frame
}
\description{
Partitions from by values in grouping column, applies a generic transform
to each group and then binds the groups back together.  Only advised for a
moderate number of groups and better if grouping column is an index.
This is powerfull
enough to implement "The Split-Apply-Combine Strategy for Data Analysis"
https://www.jstatsoft.org/article/view/v040i01
}
\details{
Note this is a fairly expensive operator, so it only makes sense to use
in situations where \code{f} itself is fairly complicated and/or expensive.
}
\examples{

library('dplyr')
d <- data.frame(group=c(1,1,2,2,2),
                order=c(.1,.2,.3,.4,.5),
                values=c(10,20,2,4,8))

# User supplied window functions.  They depend on known column names and
# the data back-end matching function names (as cumsum).
cumulative_sum <- . \%>\% arrange(order) \%>\% mutate(cv=cumsum(values))
rank_in_group <- . \%>\% mutate(constcol=1) \%>\%
          mutate(rank=cumsum(constcol)) \%>\% select(-constcol)

for(partitionMethod in c('group_by','split','extract')) {
  print(partitionMethod)
  print('cumulative sum example')
  print(d \%>\% gapply('group',cumulative_sum,ocolumn='order',
                     partitionMethod=partitionMethod))
  print('ranking example')
  print(d \%>\% gapply('group',rank_in_group,ocolumn='order',
                     partitionMethod=partitionMethod))
  print('ranking example (decreasing)')
  print(d \%>\% gapply('group',rank_in_group,ocolumn='order',decreasing=TRUE,
                     partitionMethod=partitionMethod))
}

}
