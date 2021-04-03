# our original course cost
course_cost <- 24.99
# expenses for an individual course
expenses <- 14.992
# profit on a single sale
profit <- 5

discount_amount <- (course_cost - (expenses + profit))
discount_percentage <- (discount_amount/course_cost * 100)

print(discount_amount)
print(discount_percentage)
