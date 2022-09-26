########################### Data types ###########################
#numeric - integer, double, complex
#character
#logical

#vector
#data.frame
#list

#factor
#matrix
#function
##################################################################

#basic stuff
print("hello world")
8 + 5
4^2

# VARIABLES
x <- 5
a <- 'string'
# notice they start to appear on the top-right box
# now try to change the variable in the console below (e.g. x <- 'string2')

# VECTORS
c(6, 7, 8, 9, 10) # numeric vector
c('c', 'd', 'e')  # character vector
c()

# vectors can be generated as a sequence of numbers with equal spread
1:12
seq(1, 12)
seq(1, 12, 0.5)
seq(1, 30, length = 40)

# other useful ways to generate vectors
rep(1, times = 10)
rep(c(1, 2, 3), times = 10)
rep(c(1, 2, 3), each = 10)

#vector math
a <- c(6, 7, 8, 9, 10) # create your a vector
b <- c(6, 7, 8, 9, 10) # create your b vector
a + b
a * 2

# Now try retrieving the 2nd element from your vectors


##DATA FRAMES
# Tables with named columns, which can be referenced without knowing their index
df <- data.frame(
  column1 = c(1, 4, 9),
  column2 = c(2, 5, 8),
  column3 = c(3, 6, 9),
)

employees <- data.frame(
  name = c("Anna", "Sarah", "Elon", "Johny Bravo"),
  gender = c('female', 'female', 'non-binary', 'male'),
  is_contractor = c(TRUE, TRUE, FALSE, FALSE)
)

employees$gender
employees$name

##LISTS
data_list <-
  list(c("Mon", "Tue", "Wed"),
       matrix(c(1, 2, 3, 4, -1, 9), nrow = 2),
       list("Spotify", 12.3))

names(data_list) <- c("Weekdays", "Matrix", "Misc")
print(data_list)

data_list$Weekdays
data_list$Matrix

#--------------------------------
## What happens when you do this?
test <-
  c(
    c("Mon", "Tue", "Wed"),
    matrix(c(1, 2, 3, 4, -1, 9), nrow = 2),
    list("Spotify", 12.3)
  )


##MATRIX
matrix(c(1, 2, 3, 4, 5, 6, 7, 8, 9), nrow = 3)

row1 <- c(1, 2, 3)
row2 <- c(4, 5, 6)
row3 <- c(7, 8, 9)
matrix_from_rows <- rbind(row1, row2, row3)
matrix_from_rows

col1 <- c(1, 4, 9)
col2 <- c(2, 5, 8)
col3 <- c(3, 6, 9)
cbind(col1, col2, col3)

# rbind and cbind can be used for adding new rows/columns as well
matrix1 <- matrix(1:9, nrow = 3)
cbind(matrix1, col1)

matrix_from_rows[2,]
matrix_from_rows[matrix_from_rows < 2] = 0
