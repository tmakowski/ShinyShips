context("utils")

test_that("test get_unique_rows", {
    # Assert check
    expect_error(get_unique_rows(NULL, "a"))
    expect_error(get_unique_rows(data.frame(), NULL))
    expect_error(get_unique_rows(data.frame(), character(0)))
    expect_error(get_unique_rows(data.frame(a = 1), "b"))

    # Calculation check
    df <- data.frame(A = c(1:2, 1:2), B = c("a", "b", "a", "c"))
    expect_equal(
        get_unique_rows(df, c("A", "B")),
        data.frame(A = c(1, 2, 2), B = c("a", "b", "c"))
    )
    expect_equal(
        get_unique_rows(df, "A"),
        data.frame(A = 1:2)
    )
    expect_equal(
        get_unique_rows(data.frame(A = 1:2), "A"),
        data.frame(A = 1:2)
    )
})
