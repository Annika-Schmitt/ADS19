Applied Data Science
========================================================
author: Interactive R Scripts
date: 16.07.2019
autosize: false
width: 1920
height: 1080
font-family: 'Arial'
css: mySlideTemplate.css




```r
library(tidyverse)
library(shiny)
```

Disclaimer
=====
Shiny material is forked from https://cfss.uchicago.edu/notes/intro-to-course/

The Need for interactivity
====

* Results are typically presented and shared in a static format
* Potentially underwhelming for audiences (think Hans Rosling)
* Additional questions related to their work cannot be showed immediately

> The impact of data scientists’ work depends on how well others can understand their insights to take further actions

https://medium.com/ibm-data-science-experience/shiny-a-data-scientists-best-friend-883274c9d047

Creating Microservices with Plumber
=====
* The plumber R package (Trestle Technology, LLC 2017) allows users to expose existing R code as a service available to others on the Web.

* We will not explore it in detail but it can help persist and operationalize most of the artifacts we created

* The example functionality is provided in pumber.R

```r
# plumber.R

#' Echo the parameter that was sent in
#' @param msg The message to echo back.
#' @get /echo
function(msg=""){
  list(msg = paste0("The message is: '", msg, "'"))
}

#' Plot out data from the iris dataset
#' @param spec If provided, filter the data to only this species (e.g. 'setosa')
#' @get /plot
#' @png
function(spec){
  myData <- iris
  title <- "All Species"

  # Filter if the species was specified
  if (!missing(spec)){
    title <- paste0("Only the '", spec, "' Species")
    myData <- subset(iris, Species == spec)
  }

  plot(myData$Sepal.Length, myData$Petal.Length,
       main=title, xlab="Sepal Length", ylab="Petal Length")
}


```

Running the microservice and accessing it
====

* Having set up the plumber service we can launch as follows

```r
library(plumber)
r <- plumb("Lecture Code/plumber.R")  # Where 'plumber.R' is the location of the file shown above
r$run(port=8000)
```
* Navigating the browser to http://127.0.0.1:8000/__swagger__/ we can access the service



R Shiny
====

* **Shiny** is a package from RStudio that can be used to build interactive web pages with R.

* While that may sound scary because of the words "web pages", it's geared to R users who have **no** experience with web development, and you do not need to know any HTML/CSS/JavaScript.

* You can do quite a lot with Shiny: think of it as an easy way to make an interactive web page, and that web page can seamlessly interact with R and display R objects (plots, tables, of anything else you do in R).

* To get a sense of the wide range of things you can do with Shiny, you can visit [the Shiny gallery](http://shiny.rstudio.com/gallery/), which hosts examples of basic (and complex) Shiny apps.

A comprehensive example
====
* We are building a Shiny app using a subset of the city of Chicago's [current employee data set](https://data.cityofchicago.org/Administration-Finance/Current-Employee-Names-Salaries-and-Position-Title/xzkq-xp2w)

* The city annually releases an updated file of all employees of the city government, including information on department, job title, and salary/wage. We will build an app to report information specifically for wage employees

* A final version of the app [can be seen here](https://bensoltoff.shinyapps.io/chicago-employees/)

More material
====

* If you want even more practice, another great tutorial is the [official Shiny tutorial](http://shiny.rstudio.com/tutorial/). 

* RStudio also provides a [handy cheatsheet](https://www.rstudio.com/resources/cheatsheets/) to remember all the little details after you already learned the basics.

Before we begin
====



* You'll need to have the `shiny` package, so install it.

```r
install.packages("shiny")
```

* To ensure you successfully installed Shiny, try running one of the demo apps.

```r
library(shiny)
runExample("01_hello")
```

* If the example app is running, press *Escape* to close the app, and you are ready to build your first Shiny app!

* To follow along with this lesson, fork and clone the [`shiny-demo`](https://github.com/uc-cfss/shiny-demo) Git repository which contains the data files for city employees.

Shiny app basics 
====
* Every Shiny app is composed of a two parts: a web page that shows the app to the user, and a computer that powers the app.

* The computer that runs the app can either be your own laptop (such as when you're running an app from RStudio) or a server somewhere else.

* You, as the Shiny app developer, need to write these two parts (you're not going to write a computer, but rather the code that powers the app).

* In Shiny terminology, they are called *UI* (user interface) and *server*.

***

* UI is just a web document that the user gets to see, it's HTML that you write using Shiny's functions.

* The UI is responsible for creating the layout of the app and telling Shiny exactly where things go. 



* The server is responsible for the logic of the app; it's the set of instructions that tell the web page what to show when the user interacts with the page.

Create an empty Shiny app
====

All Shiny apps follow the same template:

```r
library(shiny)
ui <- fluidPage()
server <- function(input, output) {}
shinyApp(ui = ui, server = server)
```

* This template is by itself a working minimal Shiny app that doesn't do much. It initializes an empty UI and an empty server, and runs an app using these empty parts.

* Copy this template into a new file named `app.R` in a new folder. It is **very important** that the name of the file is `app.R`, otherwise it would not be recognized as a Shiny app.

***

* It is also **very important** that you place this app in its own folder, and not in a folder that already has other R scripts or files, unless those other files are used by your app.

* After saving the file, RStudio should recognize that this is a Shiny app, and you should see the usual *Run* button at the top change to *Run App*.

Running the App
====
* Click the *Run App* button, and now your app should run.
* You won't see much because it's an empty app, but you should see that the console has some text printed in the form of `Listening on http://127.0.0.1:5274` and that a little stop sign appeared at the top of the console.
* You'll also notice that you can't run any commands in the console. This is because R is busy--your R session is currently powering a Shiny app and listening for user interaction (which won't happen because the app has nothing in it yet).

* Click the stop button to stop the app, or press the *Escape* key.

Alternate way to create a Shiny app: separate UI and server files
=====

* Another way to define a Shiny app is by separating the UI and server code into two files: `ui.R` and `server.R`.

* This is the preferable way to write Shiny apps when the app is complex and involves more code, but in this tutorial we'll stick to the simple single file.

* If you want to break up your app into these two files, you simply put all code that is assigned to the `ui` variable in `ui.R` and all the code assigned to the `server` function in `server.R`.

* When RStudio sees these two files in the same folder, it will know you're writing a Shiny app. 

Let RStudio fill out a Shiny app template for you
====

* You can also create a new Shiny app using RStudio's menu by selecting *File > New File > Shiny Web App...*.

* If you do this, RStudio will let you choose if you want a single-file app (`app.R`) or a two-file app (`ui.R`+`server.R`).

* RStudio will initialize a simple functional Shiny app with some code in it. I personally don't use this feature because I find it easier to simply type the few lines of a Shiny app and save the files.

Load the dataset
====
* The raw dataset contains information about all employees of the city of Chicago (`employees-all.csv`).

* The processed dataset we'll be using in this app is the subset of employees who are **wage** employees (paid hourly), as opposed to **salaried** employees.

* This subset is in the `employees-wage.csv` file.

* Add a line in your app to load the data into a variable called `employ`. It should look something like this (be sure to to add `library(tidyverse)` or `library(readr)` to the script so you can use the `read_csv` function):

```r
employ <- read_csv("employees-wage.csv")
```

* Place this line in your app as the third line, just after `library(shiny)` and `library(tidyverse)`. Make sure the file path and file name are correct, otherwise your app won't run. Try to run the app to make sure the file can be loaded without errors.

Build the UI: Plain Text
====

* Let's start populating our app with some elements visually. This is usually the first thing you do when writing a Shiny app - add elements to the UI.

* You can place R strings inside `fluidPage()` to render text.

```r
fluidPage("City of Chicago Wage Employees", "hourly wage")
```
* Replace the line in your app that assigns an empty `fluidPage()` into `ui` with the one above, and run the app.

* The entire UI will be built by passing comma-separated arguments into the `fluidPage()` function. By passing regular text, the web page will just render boring unformatted text.

**Exercise:** Add several more strings to `fluidPage()` and run the app. Nothing too exciting is happening yet, but you should just see all the text appear in one contiguous block.

Build the UI: Formatted text and other HTML elements
=====

* If we want our text to be formatted nicer, Shiny has many functions that are wrappers around HTML tags that format text.
* We can use the `h1()` function for a top-level header (`<h1>` in HTML), `h2()` for a secondary header (`<h2>` in HTML), `strong()` to make text bold (`<strong>` in HTML), `em()` to make text italicized (`<em>` in HTML), and many more.
* There are also functions that are wrappers to other HTML tags, such as `br()` for a line break, `img()` for an image, `a()` for a hyperlink, and others.
* All of these functions are actually just wrappers to HTML tags with the equivalent name. You can add any arbitrary HTML tag using the `tags` object, which you can learn more about by reading the help file on `tags`.

* Just as a demonstration, try replacing the `fluidPage()` function in your UI with

```r
ui <- fluidPage(
  h1("My app"),
  "Chicago",
  "Wage Employees",
  br(),
  "Hourly",
  strong("wage")
)
```

Build the UI: Add a title
====

* We could add a title to the app with `h1()`, but Shiny also has a special function `titlePanel()`.
* Using `titlePanel()` not only adds a visible big title-like text to the top of the page, but it also sets the "official" title of the web page.
* This means that when you look at the name of the tab in the browser, you'll see this title.

* Overwrite the `fluidPage()` that you experimented with so far, and replace it with the simple one below, that simply has a title and nothing else.

```r
fluidPage(
  titlePanel("City of Chicago Wage Employees")
)
```

**Exercise:** Look at the documentation for the `titlePanel()` function and notice it has another argument. Use that argument and see if you can see what it does.

Build the UI: Add a layout
====

* You may have noticed that so far, by just adding text and HTML tags, everything is unstructured and the elements simply stack up one below the other in one column.

* We'll use `sidebarLayout()` to add a simple structure. It provides a simple two-column layout with a smaller sidebar and a larger main panel.


* We'll build our app such that all the inputs that the user can manipulate will be in the sidebar, and the results will be shown in the main panel on the right.

* Add the following code after the `titlePanel()`

```r
sidebarLayout(
  sidebarPanel("our inputs will go here"),
  mainPanel("the results will go here")
)
```

* *Remember that all the arguments inside `fluidPage()` need to be separated by commas.*

Current Status
====

So far our complete app looks like this (hopefully this isn't a surprise to you)

```r
library(shiny)
library(tidyverse)

employ <- read_csv("employees-wage.csv")

ui <- fluidPage(
  titlePanel("City of Chicago Wage Employees"),
  sidebarLayout(
    sidebarPanel("our inputs will go here"),
    mainPanel("the results will go here")
  )
)

server <- function(input, output) {}

shinyApp(ui = ui, server = server)
```

**Exercise:** Add some UI into each of the two panels (sidebar panel and main panel) and see how your app now has two columns.

UI functions are simply HTML wrappers
====

* This was already mentioned, but it's important to remember: the entire UI is just HTML, and Shiny simply gives you easy tools to write it without having to know HTML.
* To convince yourself of this, look at the output when printing the contents of the `ui` variable.

```r
print(ui)
```

~~~
<div class="container-fluid">
  <h2>City of Chicago Wage Employees</h2>
  <div class="row">
    <div class="col-sm-4">
      <form class="well">our inputs will go here</form>
    </div>
    <div class="col-sm-8">the results will go here</div>
  </div>
</div>
~~~

* This should make you appreciate Shiny for not making you write horrendous HTML by hand.

Build the UI: Add inputs to the UI
=====

* Inputs are what gives users a way to interact with a Shiny app.
* Shiny provides many input functions to support many kinds of interactions that the user could have with an app.
* For example, `textInput()` is used to let the user enter text, `numericInput()` lets the user select a number, `dateInput()` is for selecting a date, `selectInput()` is for creating a select box (aka a dropdown menu).

* All input functions have the same first two arguments: `inputId` and `label`. * The `inputId` will be the name that Shiny will use to refer to this input when you want to retrieve its current value.
    * It is important to note that every input must have a unique `inputId`. If you give more than one input the same id, Shiny will unfortunately not give you an explicit error, but your app won't work correctly.
    * The `label` argument specifies the text in the display label that goes along with the input widget.
* Every input can also have multiple other arguments specific to that input type.     * The only way to find out what arguments you can use with a specific input function is to look at its help file.

**Exercise:** Read the documentation of `?numericInput` and try adding a numeric input to the UI. Experiment with the different arguments. Run the app and see how you can interact with this input. Then try different inputs types.

Input for hourly wage
====
* The first input we want to have is for specifying a wage range (minimum and maximum hourly wage).
* The most sensible types of input for this are either `numericInput()` or `sliderInput()` since they are both used for selecting numbers. If we use `numericInput()`, we'd have to use two inputs, one for the minimum value and one for the maximum. Looking at the documentation for `sliderInput()`, you'll see that by supplying a vector of length two as the `value` argument, it can be used to specify a range rather than a single number. This sounds like what we want in this case, so we'll use `sliderInput()`.

To create a slider input, a maximum value needs to be provided. We could manually determine the highest hourly wage rate in the dataset and hardcode this into the app. But we're already using R, so let's calculate it dynamically. That is, write a short piece of R code to determine the largest value in the `wage` column. `max()` does exactly that.


```r
max(employ$wage, na.rm = TRUE)
```

```
[1] 109
```

By looking at the documentation for the slider input function, the following piece of code can be constructed.

```r
sliderInput(inputId = "wage",
            label = "Wage range",
            min = 0,
            max = max(employ$wage, na.rm = TRUE),
            value = c(0, max(employ$wage, na.rm = TRUE)),
            pre = "$")
```

Place the code for the slider input inside `sidebarPanel()` (replace the text we wrote earlier with this input).

Input for full/part-time
====

* While many employees of the city are full-time workers, a large portion only work for the city part-time.
* Part-time workers are more likely to be seasonal employees, and as such their hourly wages may systematically differ from full-time employees.
* It will be helpful to include an option to filter the datset between these two types of employees.

* We could either use radio buttons or a select box for this purpose. Let's use radio buttons for now since there are only two options, so take a look at the documentation for `radioButtons()` and come up with a reasonable input function code. It should look like this:

```r
radioButtons(inputId = "full_time",
             label = "Full or part-time",
             choices = c("Full-Time", "Part-Time"))
```

* Add this input code inside `sidebarPanel()`, after the previous input (separate them with a comma).

Input for department
====

* Different departments will offer different wage structures depending on the value of the skills in demand.

* The city classifies wage employees into 22 distinct departments

***


|Department                               | Number of Employees|
|:----------------------------------------|-------------------:|
|Animal Care and Control                  |                  19|
|Aviation                                 |                1082|
|Budget & Management                      |                   2|
|Business Affairs and Consumer Protection |                   7|
|City Council                             |                  64|
|Community Development                    |                   4|
|Cultural Affairs and Special Events      |                   7|
|Emergency Management & Communications    |                1273|
|Family & Support                         |                 287|
|Finance                                  |                  44|
|Fire                                     |                   2|
|General Services                         |                 765|
|Human Resources                          |                   4|
|Law                                      |                  40|
|Mayor's Office                           |                   8|
|Police                                   |                  10|
|Procurement Services                     |                   2|
|Public Health                            |                   3|
|Public Library                           |                 299|
|Streets & Sanitation                     |                1862|
|Transportation                           |                 725|
|Water Management                         |                1513|

Input for department (2)
====

* The most appropriate input type in this case is probably the select box `selectInput()`. However we don't want to write out the entire vector by hand:


```
c("Animal Care and Control", "Aviation", "Budget & Management", "Business Affairs and Consumer Protection", "City Council", "Community Development", "Cultural Affairs and Special Events", "Emergency Management & Communications", "Family & Support", "Finance", "Fire", "General Services", "Human Resources", "Law", "Mayor's Office", "Police", "Procurement Services", "Public Health", "Public Library", "Streets & Sanitation", "Transportation", "Water Management")
```

* Instead, like before we'll extract these values directly from the data frame:

```r
selectInput(inputId = "department",
            label = "Department",
            choices = sort(unique(employ$department)),
            multiple = TRUE)
```

* Set `multiple = TRUE` so the user can select more than one department at a time.

* Add this function as well to your app

Intermediate Result
====

```r
library(shiny)
library(tidyverse)
employ <- read_csv("employees-wage.csv")
ui <- fluidPage(
  titlePanel("City of Chicago Wage Employees"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "wage",
                  label = "Wage range",
                  min = 0,
                  max = max(employ$wage, na.rm = TRUE),
                  value = c(0, max(employ$wage, na.rm = TRUE)),
                  pre = "$"),
      radioButtons(inputId = "full_time",
                   label = "Full or part-time",
                   choices = c("Full-Time", "Part-Time")),
      selectInput(inputId = "department",
                  label = "Department",
                  choices = sort(unique(employ$department)),
                  multiple = TRUE)
    ),
    mainPanel("the results will go here")
  )
)
server <- function(input, output) {}
shinyApp(ui = ui, server = server)
```


Add placeholders for outputs
====
* After creating all the inputs, we should add elements to the UI to display the outputs.
* Outputs can be any object that R creates and that we want to display in our app - such as a plot, a table, or text.
* We're still only building the UI, so at this point we can only add *placeholders* for the outputs that will determine where an output will be and what its ID is, but it won't actually show anything. Each output needs to be constructed in the server code later.

* Shiny provides several output functions, one for each type of output. Similarly to the input functions, all the output functions have an `outputId` argument that is used to identify each output, and this argument must be unique for each output.

Output for a plot of the results
====

* At the top of the main panel we'll have a plot showing the distribution of hourly wages. Since we want a plot, the function we use is `plotOutput()`.

* Add the following code into the `mainPanel()` (replace the existing text):

```r
plotOutput("hourlyPlot")
```

* This will add a placeholder in the UI for a plot named *hourlyPlot*.

**Exercise:** To remind yourself that we are still merely constructing HTML and not creating actual plots yet, run the above `plotOutput()` function in the console to see that all it does is create some HTML.

Output for a table summary of the results
====

* Below the plot, we will have a table that shows a summary of the number of employees per department currently included in the plot. To get a table, we use the `tableOutput()` function.

* Here is a simple way to create a UI element that will hold a table output:

```r
tableOutput("employTable")
```

* Add this output to the `mainPanel()` as well. Maybe add a couple `br()` in between the two outputs, just as a space buffer so that they aren't too close to each other.

Intermediate Result
====

* If you've followed along, your app should now have this code:

```r
library(shiny)
library(tidyverse)
employ <- read_csv("employees-wage.csv")
ui <- fluidPage(
  titlePanel("City of Chicago Wage Employees"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "wage",
                  label = "Wage range",
                  min = 0,
                  max = max(employ$wage, na.rm = TRUE),
                  value = c(0, max(employ$wage, na.rm = TRUE)),
                  pre = "$"),
      radioButtons(inputId = "full_time",
                   label = "Full or part-time",
                   choices = c("Full-Time", "Part-Time")),
      selectInput(inputId = "department",
                  label = "Department",
                  choices = sort(unique(employ$department)),
                  multiple = TRUE)
    ),
    mainPanel(plotOutput("hourlyPlot"),
              tableOutput("employTable"))
  )
)
server <- function(input, output) {}
shinyApp(ui = ui, server = server)
```

Implement server logic
====

* So far we only wrote code inside that was assigned to the `ui` variable (or code that was written in `ui.R`).
* Now we have to write the `server` function, which will be responsible for listening to changes to the inputs and creating outputs to show in the app.
* If you look at the server function, you'll notice that it is always defined with two arguments: `input` and `output`.
* You *must* define these two arguments! Both `input` and `output` are list-like objects.
  * `input` is a list you will read values *from*. `input` will contain the values of all the different inputs at any given time
  * `output` is a list you will write values *to*. `output` is where you will save output objects (such as tables and plots) to display in your app.

Building an output
====
Recall that we created two output placeholders: *hourlyPlot* (a plot) and *employTable* (a table). We need to write code in R that will tell Shiny what kind of plot or table to display. There are three rules to build an output in Shiny. 

1. Save the output object into the `output` list (remember the app template - every server function has an `output` argument)  
2. Build the object with a `render*` function, where `*` is the type of output
3. Access input values using the `input` list (every server function has an `input` argument)

* The third rule is only required if you want your output to depend on some input, so let's first see how to build a very basic output using only the first two rules.
* We'll create a plot and send it to the *hourlyPlot* output.
  * Since *hourlyPlot* was defined as a `plotOutput`, we must use the `renderPlot` function, and we must create a plot inside the `renderPlot` function.

```r
output$hourlyPlot <- renderPlot({
  plot(rnorm(100))
})
```
* This simple code shows the first two rules: we're creating a plot inside the `renderPlot()` function, and assigning it to *hourlyPlot* in the `output` list.
  * Remember that every output created in the UI must have a unique ID, now we see why. In order to attach an R object to an output with ID *x*, we assign the R object to `output$x`.

Making an output react to an input
====

* Now we'll take the plot one step further.
* Instead of always plotting the same plot (100 random numbers), let's use the minimum wage selected as the number of points to show.
* It doesn't make too much sense, but it's just to learn how to make an output depend on an input.

```r
output$hourlyPlot <- renderPlot({
  plot(rnorm(input$wage[1]))
})
```

* Replace the previous code in your server function with this code, and run the app. Whenever you choose a new minimum price range, the plot will update with a new number of points.
* Notice that the only thing different in the code is that instead of using the number `100` we are using `input$wage[1]`. 

Explanation
====

* What does this mean? Just like the variable `output` contains a list of all the outputs (and we need to assign code into them), the variable `input` contains a list of all the inputs that are defined in the UI. `input$wage` return a vector of length 2 containing the minimum and maximum wage.
* Whenever the user manipulates the slider in the app, these values are updated, and whatever code relies on it gets re-evaluated. This is a concept known as [**reactivity**](#reactivity-101), which we will get to in a few minutes.
* Notice that these short 3 lines of code are using all the 3 rules for building outputs:
  * we are saving to the `output` list (`output$hourlyPlot <-`)
  * we are using a `render*` function to build the output (`renderPlot({})`)
  * we are accessing an input value (`input$wage[1]`). 

Building the plot output
====

* Now we have all the knowledge required to build a plot visualizing some aspect of the data. We'll create a simple histogram of the hourly wage rate for employees by using the same 3 rules to create a plot output.

* Next we'll return a histogram of hourly wage `wage` from `renderPlot()`. Let's start with just a histogram of the whole data, unfiltered.

```r
output$hourlyPlot <- renderPlot({
  ggplot(employ, aes(wage)) +
    geom_histogram()
})
```
* If you run the app with this code inside your server, you should see a histogram in the app. But if you change the input values, nothing happens yet, so the next step is to actually filter the dataset based on the inputs.



Building the plot output (2)
====

* Recall that we have 3 inputs: `wage`, `full_time`, and `department`. We can filter the data based on the values of these three inputs.
* For now, only filter for `wage` and `full_time` -- we'll return to `department` in a little bit.
* We'll use `dplyr` functions to filter the data. Then we'll plot the filtered data instead of the original data.

```r
output$hourlyPlot <- renderPlot({
  employ %>%
    filter(full_time == input$full_time,
           wage >= input$wage[[1]],
           wage <= input$wage[[2]]) %>%
    ggplot(aes(wage)) +
    geom_histogram()
})
```

Place this code in your server function and run the app. If you change the hourly wage or full/part-time inputs, you should see the histogram update.

Read this code and understand it. You've successfully created an interactive app - the plot is changing according to the user's selection.

**Exercise:** The current plot doesn't look very nice, you could enhance the plot and make it much more pleasant to look at.

Building the table output
====

* Building the next output should be much easier now that we've done it once.
* The other output we have was called `employTable` (as defined in the UI) and should be a table summarizing the number of employees per department in the filtered data frame.
* Since it's a table output, we should use the `renderTable()` function. We'll do the exact same filtering on the data, and then simply return the summarized data as a data.frame.
* Shiny will know that it needs to display it as a table because it's defined as a `tableOutput`.

The code for creating the table output should make sense to you without too much explanation:

```r
output$employTable <- renderTable({
  employ %>%
    filter(full_time == input$full_time,
           wage >= input$wage[[1]],
           wage <= input$wage[[2]]) %>%
    count(department)
})
```

* Add this code to your server. Don't overwrite the previous definition of `output$hourlyPlot`, just add this code before or after that, but inside the server function. Run your app, and be amazed! You can now see a table showing the number of wage employees per department that match your criteria. 

Reactivity 101
====

* Shiny uses a concept called **reactive** programming.
* This is what enables your outputs to *react* to changes in inputs.
* Reactivity in Shiny is complex, but as an extreme oversimplification, it means that when the value of a variable `x` changes, then anything that relies on `x` gets re-evaluated.
* Notice how this is very different from what you are used to in R. Consider the following code:

```r
x <- 5
y <- x + 1
x <- 10
```

* What is the value of `y`? It's 6. But in reactive programming, if `x` and `y` are reactive variables, then the value of `y` would be 11 because it would be updated whenever `x` is changed.
* This is a very powerful technique that is very useful for creating the responsiveness of Shiny apps, but it might be a bit weird at first because it's a very different concept from what you're used to.
* Only *reactive* variables behave this way, and in Shiny all inputs are automatically reactive. That's why you can always use `input$x` in render functions, and you can be sure that whatever output depends on `x` will use the updated value of `x` whenever `x` changes.

Creating and accessing reactive variables
====

* One very important thing to remember about reactive variables (such as the `input` list) is that **they can only be used inside reactive contexts**.
* Any `render*` function is a reactive context, so you can always use `input$x` or any other reactive variable inside render functions.
* There are two other common reactive contexts that we'll get to in a minute: `reactive({})` and `observe({})`.
* To show you what this means, let's try accessing the price input value in the server function, without explicitly being inside a reactive context.
* Simply add `print(input$wage)` inside the `server` function, and you will get an error when running the app:

~~~
Operation not allowed without an active reactive context. (You tried to do something that can only be done from inside a reactive expression or observer.)
~~~

* Shiny is very clear about what the error is: we are trying to access a reactive variable outside of a reactive context.
* To fix this, we can use the `observe({})` function to access the `input` variable.
* Inside the server, replace `print(input$wage)` with `observe({ print(input$wage) })`, and now the app should run fine.
* Note that this `observe({})` statement *depends* on `input$wage`, so whenever you change the value of the price, the code inside this `observe({})` will run again, and the new value will be printed.
* This is actually a very simple yet useful debugging technique in Shiny: often you want to know what value a reactive variable holds, so you need to remember to wrap the `cat(input$x)` or `print(input$x)` by an `observe({})`.

Create your own reactive variable
====
* So far we only saw one reactive variable: the `input` list. You can also create your own reactive variables using the `reactive({})` function.
* The `reactive({})` function is similar to `observe({})` in that it is also a reactive context, which means that it will get re-run whenever any of the reactive variables in it get updated.
* The difference between them is that `reactive({})` returns a value. To see it in action, let's create a variable called `wageDiff` that will be the difference between the maximum and minimum wage selected.
* If you try to naively define `wageDiff <- diff(input$wage)`, you'll see the same error as before about doing something outside a reactive context. This is because `input$wage` is a reactive variable, and we can't use a reactive variable outside a reactive context.
* Since we want to assign a value, we use the `reactive({})` function. Try adding the following line to your server:

```r
wageDiff <- reactive({
  diff(input$wage)
})
```

Shiny Resources
====

* [Shiny official tutorial](http://shiny.rstudio.com/tutorial)
* [Shiny cheatsheet](http://shiny.rstudio.com/images/shiny-cheatsheet.pdf)
* [Lots of short useful articles about different topics in Shiny](http://shiny.rstudio.com/articles)
* [Shiny in Rmarkdown](http://rmarkdown.rstudio.com/authoring_shiny.html)
* Get help from the [Shiny Google group](https://groups.google.com/forum/#!forum/shiny-discuss) or [StackOverflow](http://stackoverflow.com/questions/tagged/shiny)
* [Publish your apps for free with shinyapps.io](http://www.shinyapps.io)
* [Learn about how reactivity works](http://shiny.rstudio.com/articles/understanding-reactivity.html)
* [Learn about useful debugging techniques](http://shiny.rstudio.com/articles/debugging.html)
* [Shiny tips & tricks for improving your apps and solving common problems](http://deanattali.com/blog/advanced-shiny-tips)

