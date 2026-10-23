
# Check that the machine learning package exists
stopifnot(requireNamespace("rpart", quietly = TRUE))

# Run the training and evaluation script


# Verify that the model was saved
stopifnot(file.exists("artifacts/iris_model.rds"))

# Read the saved model
result <- readRDS("artifacts/iris_model.rds")

# Check the model and evaluation result
stopifnot(inherits(result$model, "rpart"))
stopifnot(is.finite(result$accuracy))
stopifnot(result$accuracy >= 0.70)

cat("All automated tests passed!\n")
