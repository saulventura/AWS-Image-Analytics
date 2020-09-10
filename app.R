# 1. Setup -----------------------------------------------------------------------

# . 1.1. Restrictions ------------------------------------------------------------
options(shiny.maxRequestSize = 3*1024^2)


# . 1.2. Libraries ---------------------------------------------------------------
library(shiny)
library(shinydashboard)
library(shinyjs)
library(DT)
library(readr)
library(shinycssloaders)
library(shinybusy)
library(reshape2)
library(shinyalert)
library(ggplot2)
library(htmlwidgets)
library(plotly)
library(shinyWidgets)
library(tidyverse)
library(plyr)
library(dplyr)
library(plotly)
library(reticulate)
library(base64enc)
library(treemap)
library(RColorBrewer)
library(highcharter)
library(imager)
library(magick)
library(scales)
library(shinyTree)
library(jsonlite)
library(listviewer)
library(slickR)

# . 1.2. Javascripts--------------------------------------------------------------
# . . 1.2.1. JS used for image gallery to control click event-----------------------



js_fd <- "
$(document).ready(function(){
  $('#fd_slickr').on('setPosition', function(event, slick) {
    var index = slick.currentSlide + 1;
    Shiny.setInputValue('imageIndex', index);
  });
})"



js_cr <- "
$(document).ready(function(){
  $('#cr_slickr').on('setPosition', function(event, slick) {
    var index = slick.currentSlide + 1;
    Shiny.setInputValue('imageIndex', index);
  });
})"





# 2. UI -----------------------------------------------------------------------

# . 2.1. Adding UI elements----------------------------------------------------


sidebar = dashboardSidebar(uiOutput("sidebarpanel") , collapsed = FALSE, disable = FALSE) 

body <- dashboardBody(
  shinyjs::useShinyjs(),
  tabItems(
    
    tabItem(tabName ="facialdetection", class = "active", 
         
            fluidRow(
             column(width=7,
                       box(width=12, id='fd_box', collapsible = TRUE,  title="Image for Facial Detection/Analysis",status="primary",solidHeader = TRUE,height='800',
                           fluidRow(style='height:12vh',
                                    column(width=12,
                                           fileInput(inputId = "fd_file_input",label = "Drag and drop your Image here",multiple = FALSE,
                                                     buttonLabel = list(icon("folder"),"Select File"),accept = c('image/png', 'image/jpeg'),
                                                     placeholder = "No file selected")
                                   )# column close
                           ),# fluidRow close
                           fluidRow(style='height:6vh',     
                                    column(width=12,align="center",
                                          disabled(actionButton(inputId = "fd_process", label = "Process", icon = icon("caret-square-right")))
                                    )# column close
                           ),# fluidRow close
                           fluidRow(
                             column(width=12, align="center",
                                    tags$head(tags$style(type="text/css","#fd_imageview img {max-width: 100%; width: 100%; height: auto}" )),      
                                    div(plotlyOutput("fd_imageview",inline=F, width="auto"), align = "center")
                             )# column close
                           )# fluidRow close
                       )# box close
               ),# column close

              column(width=5,
                   #  fluidRow( 
                       box(width=12, collapsible = TRUE, title="Face Detection/Analysis Results", status="primary",solidHeader = TRUE,height='800',
                           fluidRow(
                                    column(width=3),
                                    column(width=6,
                                           tags$head(tags$script(js_fd)),
                                           tags$div(
                                           slickROutput(outputId ="fd_slickr",height = "100")
                                            )
                                    ), # column close                                   
                                    column(width=3)
                           ), # fluidRow close
                           fluidRow(
                                    column(width=12,
                                           htmlOutput("fd_count_result"),
                                           jsoneditOutput( "fd_jsed", height="600")
                                            
                                    )# column close
                           )# fluidRow close
                       )# box close
                     )# fluidRow close
            ) #fluidrow close    
       # )# box close   
     ), #tabItem close
    
    tabItem(tabName ="celebrityrecognition", 
 
            fluidRow(
              column(width=7,
                     box(width=12, id='cr_box', collapsible = TRUE,  title="Image for Celebrity Recognition",status="primary",solidHeader = TRUE,height='800',
                         fluidRow(style='height:12vh',
                                  column(width=12,
                                         fileInput(inputId = "cr_file_input",label = "Drag and drop your Image here",multiple = FALSE,
                                                   buttonLabel = list(icon("folder"),"Select File"),accept = c('image/png', 'image/jpeg'),
                                                   placeholder = "No file selected")
                                  )# column close
                         ),# fluidRow close
                         fluidRow(style='height:6vh',     
                                  column(width=12,align="center",
                                         disabled(actionButton(inputId = "cr_process", label = "Process", icon = icon("caret-square-right")))
                                  )# column close
                         ),# fluidRow close
                         fluidRow(
                           column(width=12, align="center",
                                  tags$head(tags$style(type="text/css","#cr_imageview img {max-width: 100%; width: 100%; height: auto}" )),      
                                  div(plotlyOutput("cr_imageview",inline=F, width="auto"), align = "center")
                           )# column close
                         )# fluidRow close
                     )# box close
              ),# column close
              
              column(width=5,
                     #  fluidRow( 
                     box(width=12, collapsible = TRUE, title="Celebrity Recognition Results", status="primary",solidHeader = TRUE,height='800',
                         fluidRow(
                           column(width=3),
                           column(width=6,
                                  tags$head(tags$script(js_cr)),
                                  tags$div(
                                    slickROutput(outputId ="cr_slickr",height = "100")
                                  )
                           ), # column close                                   
                           column(width=3)
                         ), # fluidRow close
                         fluidRow(
                           column(width=12,
                                  htmlOutput("cr_count_result"),
                                  jsoneditOutput( "cr_jsed", height="600")
                                  
                           )# column close
                         )# fluidRow close
                     )# box close
              )# fluidRow close
            ) #fluidrow close    
            # )# box close   
    ), #tabItem close    
    
    
    tabItem(tabName ="objectdetection", 
            fluidRow(
              column(width=7,
                     box(width=12, collapsible = TRUE,  title="Image for Object/Scene Detection",status="primary",solidHeader = TRUE,height='800',
                           fluidRow(style='height:12vh',
                                    column(width=12,
                                           fileInput(inputId = "od_file_input",label = "Drag and drop your Image here",multiple = FALSE,
                                                     buttonLabel = list(icon("folder"),"Select File"),accept = c('image/png', 'image/jpeg'),
                                                     placeholder = "No file selected")
                                    )# column close
                           ),# fluidRow close
                           fluidRow(style='height:6vh',     
                                    column(width=12,align="center",
                                           disabled(actionButton(inputId = "od_process", label = "Process", icon = icon("caret-square-right")))
                                    )# column close
                           ),# fluidRow close
                           fluidRow(
                                    column(width=12,
                                           tags$head(tags$style(type="text/css","#od_imageview img {max-width: 100%; width: 100%; height: auto}" )),      
                                           uiOutput("od_imageview")
                             )# column close
                           )# fluidRow close
                       )# box close
              ),# column close
              
              column(width=5,
                       box(width=12, collapsible = TRUE, title="Object/Scene Detection Results", status="primary",solidHeader = TRUE,height='800',
                           fluidRow(style='height:18vh',
                                    column(width=12,
                                           br(),br(),br(),
                                           htmlOutput("od_count_result")
                                    ) # column close
                           ), # fluidRow close
                           fluidRow(
                                    column(width=12,
                                          highchartOutput('od_treemap')
                                    ) # column close
                           )# fluidrow close     
                       )# box close
              )# column close                          
            )# fluidrow close    
    ),# tabItem close       
    
    tabItem(tabName ="textinimage", 
            fluidRow(
              column(width=7,
                     box(width=12, collapsible = TRUE,  title="Image for Text Detection",status="primary",solidHeader = TRUE,height='800',
                         fluidRow(style='height:12vh',
                                  column(width=12,
                                         fileInput(inputId = "ti_file_input",label = "Drag and drop your Image here",multiple = FALSE,
                                                   buttonLabel = list(icon("folder"),"Select File"),accept = c('image/png', 'image/jpeg'),
                                                   placeholder = "No file selected")
                                  )# column close
                         ),# fluidRow close
                         fluidRow(style='height:6vh',     
                                  column(width=12,align="center",
                                         disabled(actionButton(inputId = "ti_process", label = "Process", icon = icon("caret-square-right")))
                                  )# column close
                         ),# fluidRow close
                         fluidRow(
                           column(width=12,
                                  tags$head(tags$style(type="text/css","#ti_imageview img {max-width: 100%; width: 100%; height: auto}" )),      
                                  uiOutput("ti_imageview")
                           )# column close
                         )# fluidRow close
                     )# box close
              ),# column close
              
              column(width=5,
                     box(width=12, collapsible = TRUE, title="Text Detection Results", status="primary",solidHeader = TRUE,height='800',
                         fluidRow(style='height:6vh',
                                  column(width=12,
                                         htmlOutput("ti_count_result"),
                                         br()
                                        
                                  ) # column close
                         ), # fluidRow close
                         fluidRow(style='height:8vh',
                                  column(width=12,
                                         tags$style(HTML("
                                                  #ti_lines_text {
                                                    overflow-y:auto ;
                                                    font-size: 12px;
                                                    color:darkblue;
                                                    font-weight: bold;
                                                    font-style: italic;
                                                         }
                                                    ")),
                                         uiOutput("ti_lines_text"),
                                         br()
                                  ) # column close
                         ), # fluidRow close                        
                         
                         fluidRow(
                                 column(width=12,
                                     jsoneditOutput( "ti_jsed", height="490")
                                 ) # column close
                         )# fluidrow close     
                     )# box close
              )# column close                          
            )# fluidrow close    
    ),# tabItem close       
    
    
    
    tabItem("about",
            tags$div(
              tags$h4("MachineHack - AWS Hackathon"), 
              tags$a(href="https://www.machinehack.com/hackathons/machine_learning_hackathon_in_association_with_amazon_web_services", "Hackathon Website"),
              tags$br(),tags$br(),
              "This app was built with/using R Shiny, Python, and AWS. It is hosted on Shinyapps.io",tags$br(),
              "",
              tags$h5("Team"),
              tags$ul(
              tags$li("Saul Ventura")
              )
            )
    )
    
  ) #tabitems close
  
)



notifications <-
  dropdownMenu(
    type = "tasks",
    headerText = '',
    badgeStatus = "info",
    notificationItem(text = "GitHub",
                     icon("github-alt"),
                     href = "https://github.com/saulventura"),
    notificationItem(text = "Linkedin",
                     icon("linkedin"),
                     href = "https://www.linkedin.com/in/saul-ventura/")
    
  )


header = dashboardHeader( title = 'AWS Image Analytics' ,
                          notifications)


ui = dashboardPage(header, sidebar, body)



# 3. Server -------------------------------------------------------------------

server = function(input, output, session)  

# . 3.1. Creating a Python virtual environment---------------------------------
{  

  

  if (1 == 1) {
    # Python libraries to be installed
    
    
    show_modal_spinner(
      spin = "fading-circle",
      color = "#112446",
      text = "Initializing Environment....Please wait",
      session = shiny::getDefaultReactiveDomain()
    )
    
    
    python_libraries = c('boto3',
                         'pillow',
                         'ipython',
                         'numpy',
                         'virtualenv',
                         'matplotlib',
                         "pandas")
    
    virtualenv_dir = 'example_env_name'
    python_path = 'python3'
    
    reticulate::virtualenv_create(envname = virtualenv_dir, python = python_path)
    reticulate::virtualenv_install(virtualenv_dir,
                                   packages = python_libraries,
                                   ignore_installed = TRUE)
    reticulate::use_virtualenv(virtualenv_dir, required = T)
    
    
    remove_modal_spinner(session = getDefaultReactiveDomain())
  }
  
  
  
  
# . 3.2. Creating reactive variables-------------------------------------------
  
  USER = reactiveValues(
    positions  = NULL,
    width1 = NULL,
    height1 = NULL,
    fd_image_processed = NULL,
    fd_count_result = NULL,
    fd_base64 = NULL,
    fd_faceDetail = NULL,
    fd_json_file = NULL,
    fd_x = NULL,
    fd_y = NULL,
    fd_plot_height = NULL,
    fd_img = NULL,
    fd_img_list = NULL,
    fd_img_list_item = NULL,    
    
    cr_image_processed = NULL,
    cr_count_result = NULL,
    cr_base64 = NULL,
    cr_faceDetail = NULL,
    cr_json_file = NULL,
    cr_x = NULL,
    cr_y = NULL,
    cr_plot_height = NULL,
    cr_img = NULL,
    cr_img_list = NULL,
    cr_img_list_item = NULL,     
    
    r_aws_access_key_id = NULL ,
    r_aws_secret_access_key = NULL,

    od_base64 = NULL,
    od_objects = NULL,
    od_image_processed = NULL,
    od_count_result = NULL ,
    
    ti_base64 = NULL ,
    ti_image_processed = NULL,
    ti_count_result = NULL,
    ti_lines_text = NULL ,
    ti_faceDetail= NULL 
    
   
  )
  
  
# . 3.3. Credentials to AWS----------------------------------------------------
  
  USER$r_aws_access_key_id  =  Sys.getenv("AWS_ACCESS_KEY_ID")
  USER$r_aws_secret_access_key = Sys.getenv("AWS_SECRET_ACCESS_KEY")
  
  
# . 3.4. Creating Menu options-------------------------------------------------
  
  
  output$sidebarpanel = renderUI({
    dashboardSidebar(
      sidebarMenu(
        br(),
        menuItem(
          strong("Face Detection/Analysis"),
          tabName = "facialdetection",
          icon = icon("address-card")
        ) ,
        
        menuItem(
          strong("Celebrity Recognition"),
          tabName = "celebrityrecognition",
          icon = icon("star")
        ) ,

        menuItem(
          strong("Object/Scene Detection"),
          tabName = "objectdetection",
          icon = icon("object-group")
        ),
        
        menuItem(
          strong("Text in Image"),
          tabName = "textinimage",
          icon = icon("file-invoice")
        ) ,
        
        
        br(),
        br(),
        br(),
        br(),
        br(),
        br(),
        hr(),
        menuItem(
          strong("About"),
          tabName = "about",
          icon = icon("question")
        ),
        hr()
      )
    )
  })
  
  

  
# 4. Processes-----------------------------------------------------------------  
# . 4.1. Face Analysis--------------------------------------------------------- 
  
# . . 4.1.1 Reading Image file------------------------------------------------- 
  
  
  observeEvent(input$fd_file_input, {
    if (length(input$fd_file_input$datapath))
      
    img = magick::image_read(input$fd_file_input$datapath)
    imgHeight <- magick::image_info(img)$height
    imgWidth <- magick::image_info(img)$width
    
    
    width2 = session$clientData[["output_fd_imageview_width"]]
    height2 = session$clientData[["output_fd_imageview_height"]]
    
    img = magick::image_scale(img, paste0(width2, 'x', imgHeight * width2 / imgWidth , '!'))
    
    magick::image_write(img,
                        path = input$fd_file_input$name  ,
                        quality = 100)
    
    enable("fd_process")
    
    USER$fd_image_processed = NULL
    USER$fd_count_result = NULL
    USER$fd_img_list = NULL
  })
  
# . . 4.1.2 Displaying Image Pre and Post Process------------------------------   
  
#  Pre-process  Image
  
  output$fd_imageview = renderPlotly({
    if (!is.null(input$fd_file_input)) {

      
      img = image_read(input$fd_file_input$name)
      imgHeight <- magick::image_info(img)$height
      imgWidth <- magick::image_info(img)$width
      
      fig = plot_ly(source = 'fd_source',
                    width = imgWidth ,
                    height = imgHeight)
      
      fig = fig %>% layout(xaxis = list(range = c(0, imgWidth)),
                            yaxis = list(range = c(0, imgHeight)))  %>%
        layout(
          showlegend = F,
          xaxis = list(showticklabels = F),
          yaxis = list(showticklabels = F),
          images = list(
            list(
              source =   base64enc::dataURI(file = input$fd_file_input$datapath, mime = "image/png"),
              xref = "paper",
              yref = "paper",
              x = 0,
              y = 1,
              # sizing = "stretch",
              #xanchor = "left", yanchor = "bottom",
              sizex = 1,
              sizey = 1,
              opacity = 1,
              layer = "below"
            )
            
          )
        )  %>%
        layout(
          xaxis = list(autorange = F, showgrid = F),
          yaxis = list(autorange = F, showgrid = F)
        ) %>%
        layout(margin = list(
          l = 0,
          r = 0,
          b = 0,
          t = 0,
          pad = 0
        ))  %>%
        # layout(autosize=T ) %>%
        
        config(
          displaylogo = FALSE,
          doubleClick = F,
          modeBarButtonsToRemove = c(
            "zoom2d",
            "pan2d",
            "select2d",
            "lasso2d",
            "autoScale2d",
            "resetScale2d",
            "hoverClosestCartesian",
            "hoverCompareCartesian",
            "toggleSpikelines",
            "zoomIn2d",
            "zoomOut2d"
            
          )
        )   %>%
        layout(dragmode = FALSE)
      

      
      
      
#  Post-process  Image      

      if (!is.null(USER$fd_image_processed)  )  {
        if( !USER$fd_count_result > 0  ) return(fig)
          
        img = image_read(paste0('', as.character(USER$fd_image_processed)))
        USER$fd_img = img
        imgHeight <- magick::image_info(img)$height
        imgWidth <- magick::image_info(img)$width
        
        
        coordinates = list()
        i = 0
        for (l_faceDetail in USER$fd_faceDetail) {
          i = i + 1
          box = l_faceDetail[['BoundingBox']]
          left = imgWidth * box[['Left']]
          top = imgHeight * box[['Top']]
          width = imgWidth * box[['Width']]
          height = imgHeight * box[['Height']]
          
          points_list = list(
            list(left, top),
            list(left + width, top),
            list(left + width, top + height),
            list(left , top + height),
            list(left, top)
          )
          coordinates[[i]] =  points_list
        }
        USER$fd_plot_height = imgHeight
        
        x = list()
        x1 = list()
        for (i in 1:length(coordinates))
        {
          x1 = list()
          for (j in 1:5)
          {
            k = j
            if (j == 5) {
              k = 1
            }
            x1[[j]] = unlist(coordinates[[i]][[k]][1])
          }
          x[[i]] = x1
        }
        
        y = list()
        y1 = list()
        for (i in 1:length(coordinates))
        {
          y1 = list()
          for (j in 1:5)
          {
            k = j
            if (j == 5) {
              k = 1
            }
            y1[[j]] = imgHeight - unlist(coordinates[[i]][[k]][2])
          }
          y[[i]] = y1
        }
        
        USER$fd_x = x
        USER$fd_y = y
        
        agerange = list()
        i = 0
        for (l_faceDetail in USER$fd_faceDetail) {
          i = i + 1
          agerange[[i]] = list(l_faceDetail[['AgeRange']]['Low'], l_faceDetail[['AgeRange']]['High'])
        }
        
        
        confidence = list()
        i = 0
        for (l_faceDetail in USER$fd_faceDetail) {
          i = i + 1
          confidence[[i]] = list(l_faceDetail[['Confidence']])
        }
        
        
        gender = list()
        i = 0
        for (l_faceDetail in USER$fd_faceDetail) {
          i = i + 1
          gender[[i]] = list(l_faceDetail[['Gender']])
        }

        smile = list()
        i = 0
        for (l_faceDetail in USER$fd_faceDetail) {
          i = i + 1
          smile[[i]] = list(l_faceDetail[['Smile']])
        }
 
        fig = plot_ly(source = 'fd_source',
                  width = imgWidth ,
                  height = imgHeight)#USER$height1)
        
        fig = fig %>% layout(# title = "hover on <i>points</i> or <i>fill</i>",
          xaxis = list(range = c(0, imgWidth)),
          yaxis = list(range = c(0, imgHeight)))  %>%
          layout(
            showlegend = F,
            xaxis = list(showticklabels = F),
            yaxis = list(showticklabels = F),
            
            images = list(
               list(
                source =   base64enc::dataURI(file = USER$fd_image_processed, mime = "image/png"),
                 xref = "paper",
                yref = "paper",
                x = 0,
                y = 1,
                sizing = "stretch",
                #xanchor = "left", yanchor = "bottom",
                sizex = 1,
                sizey = 1,
                opacity = 1,
                layer = "below"
              )
              
            )
          )  %>%
          layout(
            xaxis = list(autorange = F, showgrid = F),
            yaxis = list(autorange = F, showgrid = F)
          ) %>%
          layout(margin = list(
            l = 0,
            r = 0,
            b = 0,
            t = 0,
            pad = 0
          ))  %>%
          # layout(autosize=T ) %>%
          
          config(
            displaylogo = FALSE,
            doubleClick = F,
            modeBarButtonsToRemove = c(
              "zoom2d",
              "pan2d",
              "select2d",
              "lasso2d",
              "autoScale2d",
              "resetScale2d",
              "hoverClosestCartesian",
              "hoverCompareCartesian",
              "toggleSpikelines",
              "zoomIn2d",
              "zoomOut2d"
            )
          )   %>%
          layout(dragmode = FALSE)
        

        for (i in 1:length(USER$fd_faceDetail)) {
          fig = fig %>%
            add_trace(
              key = i,
              x = x[[i]],
              y = y[[i]],
              type = 'scatter',
              fill = 'toself',
              fillcolor = 'rgba(147,112,219,0.1)',
              hoveron = 'fills',
              marker = list(color = 'rgba(147,112,219,0.1)'),
              line = list(color = '#3de6f2',
                          width = 2),
              text = sprintf("%s  %s<br>(%s - %s) Years Old<br>%s %s", 
                             scales::percent(as.numeric(gender[[i]][[1]][[2]]), scale = 1, accuracy = .01), gender[[i]][[1]][[1]] , 
                             agerange[[i]][[1]][[1]], agerange[[i]][[2]][[1]],
                             scales::percent(as.numeric(smile[[i]][[1]][[2]]), scale = 1, accuracy = .01), ifelse(smile[[i]][[1]][[1]], 'Smiling', 'Not Smiling')),
             hoverinfo = 'text'
              
            )
        }
        
        fd_file_name = input$fd_file_input$name
        fd_img_list = NULL
        for (i in 1:(USER$fd_count_result)) {

          l_crop = paste0(
            as.character((x[[i]][[2]][[1]]) - (x[[i]][[1]][[1]])),
            'x',
            as.character((y[[i]][[1]][[1]]) - (y[[i]][[3]][[1]])),
            '+',
            as.character((x[[i]][[1]][[1]])),
            '+',
            as.character(imgHeight - (y[[i]][[1]][[1]]))
          )
          
          crop = image_crop(img, l_crop)
          img1 <- image_flatten(crop, "Modulate")
          
          img1 = crop
          
          img1 = image_scale(img1, "60")
          
          tmp_output_file = paste0('www/images/', 'tmp_', i, '_', fd_file_name)
          tmpfile =  magick::image_write(img1,
                                         path = tmp_output_file,
                                         format = "jpg",
                                         quality = 100)
          tmp_output_file = paste0('www/images/', 'tmp_', i, '_', fd_file_name)
          
          fd_img_list <- c(fd_img_list, tmp_output_file)

        }
        
        USER$fd_img_list = fd_img_list
        fig
        
      }
      else{

        fig
      }
      
    }
    
  })
  
  
# . . 4.1.3 Calling AWS service through Python---------------------------------    
  
  
  observeEvent(input$fd_process,
               {
                 if (is.null(input$fd_file_input$name)) {
                   return()
                 }
                 show_modal_spinner(
                   spin = "fading-circle",
                   color = "#112446",
                   text = "Face Detection/Analysis in progress....Please wait",
                   session = shiny::getDefaultReactiveDomain()
                 )
                 
                 # python file to invoke facial analysis from AWS
                 
                 reticulate::py_run_file("facial_analysis.py")
                 
                 reticulate::py_run_string(
                   paste0(
                     "
photo = '",
                     input$fd_file_input$name   ,
                     "'
r_aws_access_key_id = '",
                     USER$r_aws_access_key_id   ,
                     "'
r_aws_secret_access_key = '",
                     USER$r_aws_secret_access_key   ,
                     "'

results = show_faces(photo,r_aws_access_key_id,r_aws_secret_access_key)
print(0)
print(results)

fd_image_result= results[0]
fd_count_result = results[1]
fd_faceDetail = results[2]
#fd_json_file = results[3]

"
                   )
                 )
                 
                 USER$fd_image_processed = py$fd_image_result
                 USER$fd_count_result = py$fd_count_result
                 USER$fd_faceDetail = py$fd_faceDetail
                 #USER$fd_json_file = py$fd_json_file
                 disable("fd_process")
                 remove_modal_spinner(session = getDefaultReactiveDomain())
                 
                 
               })
  
  
# . . 4.1.4 Image Gallery for facial analysis----------------------------------    
  
  
  output$fd_slickr <- renderSlickR({

    if (is.null(USER$fd_img_list))
      return()

    img_list = USER$fd_img_list

    USER$fd_img_list_item = 1
    
    slick1 = slickR(img_list , slideId = 'fd1')
    
    
  })
  
  
  shiny::observeEvent(input$fd_slickr_current, {

    if (is.null(USER$fd_img_list))
      return()
    
    clicked_slide    = input$fd_slickr_current$.clicked
    relative_clicked    = input$fd_slickr_current$.relative_clicked
    active_slide     = input$fd_slickr_current$.slide
    USER$fd_img_list_item = as.numeric(input[["imageIndex"]]) 

  })
  
  
# . . 4.1.5 JSON file viewer for facial analysis details-----------------------    
  
  
  output$fd_jsed <- renderJsonedit({

    if (is.null(USER$fd_img_list)) {
      return()
    }
    
    i = USER$fd_img_list_item

    fd_details = USER$fd_faceDetail[[i]]
    fd_details[['BoundingBox']] = NULL
    
    jsonedit(
      fd_details,
      mode = "view",
      modes = c("code", "form", "text", "view")
      ,
      "change" = htmlwidgets::JS(
        'function(){
        console.log( event.currentTarget.pparentElement.editor.get() )
      }'
      )
    ) %>%
      onRender("function(el,fd_details,data) {this.editor.expandAll();}")
    
  })
  
  output$fd_count_result <- renderText({
    if(is.null(USER$fd_count_result)){return()}
    HTML(paste0('<br>' ,"<font color=\"#2b478c\">" ,"Faces detected: ",'<b>',USER$fd_count_result , "</b></font>" ))
  })
  
  
  
  # . 4.2. Celebrity Recognition------------------------------------------------- 
  
  # . . 4.2.1 Reading Image file------------------------------------------------- 
  
  
  observeEvent(input$cr_file_input, {
    if (length(input$cr_file_input$datapath))
      
    img = magick::image_read(input$cr_file_input$datapath)
    imgHeight <- magick::image_info(img)$height
    imgWidth <- magick::image_info(img)$width
    
    
    width2 = session$clientData[["output_cr_imageview_width"]]
    height2 = session$clientData[["output_cr_imageview_height"]]
    
    img = magick::image_scale(img, paste0(width2, 'x', imgHeight * width2 / imgWidth , '!'))
    
    magick::image_write(img,
                        path = input$cr_file_input$name  ,
                        quality = 100)
    
    enable("cr_process")
    
    USER$cr_image_processed = NULL
    USER$cr_count_result = NULL
    USER$cr_img_list = NULL
  })
  
  # . . 4.2.2 Displaying Image Pre and Post Process------------------------------   
  
  #  Pre-process  Image
  
  output$cr_imageview = renderPlotly({
    if (!is.null(input$cr_file_input)) {

      
      img = image_read(input$cr_file_input$name)
      imgHeight <- magick::image_info(img)$height
      imgWidth <- magick::image_info(img)$width
      
      fig = plot_ly(source = 'cr_source',
                    width = imgWidth ,
                    height = imgHeight)
      
      fig = fig %>% layout(xaxis = list(range = c(0, imgWidth)),
                           yaxis = list(range = c(0, imgHeight)))  %>%
        layout(
          showlegend = F,
          xaxis = list(showticklabels = F),
          yaxis = list(showticklabels = F),
          images = list(
            list(
              source =   base64enc::dataURI(file = input$cr_file_input$datapath, mime = "image/png"),
              xref = "paper",
              yref = "paper",
              x = 0,
              y = 1,
              # sizing = "stretch",
              #xanchor = "left", yanchor = "bottom",
              sizex = 1,
              sizey = 1,
              opacity = 1,
              layer = "below"
            )
            
          )
        )  %>%
        layout(
          xaxis = list(autorange = F, showgrid = F),
          yaxis = list(autorange = F, showgrid = F)
        ) %>%
        layout(margin = list(
          l = 0,
          r = 0,
          b = 0,
          t = 0,
          pad = 0
        ))  %>%
        # layout(autosize=T ) %>%
        
        config(
          displaylogo = FALSE,
          doubleClick = F,
          modeBarButtonsToRemove = c(
            "zoom2d",
            "pan2d",
            "select2d",
            "lasso2d",
            "autoScale2d",
            "resetScale2d",
            "hoverClosestCartesian",
            "hoverCompareCartesian",
            "toggleSpikelines",
            "zoomIn2d",
            "zoomOut2d"
            
          )
        )   %>%
        layout(dragmode = FALSE)
      
      
      #  Post-process  Image      

      if (!is.null(USER$cr_image_processed)  )  {
        if( USER$cr_count_result == 0  ) return(fig)

        img = image_read(paste0('', as.character(USER$cr_image_processed)))
        USER$cr_img = img
        imgHeight <- magick::image_info(img)$height
        imgWidth <- magick::image_info(img)$width
        
        
        coordinates = list()
        i = 0
        for (l_faceDetail in USER$cr_faceDetail) {
          i = i + 1
          box = l_faceDetail[['Face']][['BoundingBox']]
          left = imgWidth * box[['Left']]
          top = imgHeight * box[['Top']]
          width = imgWidth * box[['Width']]
          height = imgHeight * box[['Height']]
          
          points_list = list(
            list(left, top),
            list(left + width, top),
            list(left + width, top + height),
            list(left , top + height),
            list(left, top)
          )
          coordinates[[i]] =  points_list
        }
        USER$cr_plot_height = imgHeight
        
        x = list()
        x1 = list()
        for (i in 1:length(coordinates))
        {
          x1 = list()
          for (j in 1:5)
          {
            k = j
            if (j == 5) {
              k = 1
            }
            x1[[j]] = unlist(coordinates[[i]][[k]][1])
          }
          x[[i]] = x1
        }
        
        y = list()
        y1 = list()
        for (i in 1:length(coordinates))
        {
          y1 = list()
          for (j in 1:5)
          {
            k = j
            if (j == 5) {
              k = 1
            }
            y1[[j]] = imgHeight - unlist(coordinates[[i]][[k]][2])
          }
          y[[i]] = y1
        }
        
        USER$cr_x = x
        USER$cr_y = y
        
        
        
        confidence = list()
        i = 0
        for (l_faceDetail in USER$cr_faceDetail) {
          i = i + 1
          confidence[[i]] =list(l_faceDetail[['Face']][['Confidence']])
        }
        
        
        name = list()
        i = 0
        for (l_faceDetail in USER$cr_faceDetail) {
          i = i + 1
          name[[i]] = list(l_faceDetail[['Name']])
        }
        
        url = list()
        i = 0
        for (l_faceDetail in USER$cr_faceDetail) {
          i = i + 1
          url[[i]] = list(l_faceDetail[['Urls']])
        }
        
        
        
        
        fig = plot_ly(source = 'cr_source',
                      width = imgWidth ,
                      height = imgHeight)#USER$height1)
        
        fig = fig %>% layout(# title = "hover on <i>points</i> or <i>fill</i>",
          xaxis = list(range = c(0, imgWidth)),
          yaxis = list(range = c(0, imgHeight)))  %>%
          layout(
            showlegend = F,
            xaxis = list(showticklabels = F),
            yaxis = list(showticklabels = F),
            
            images = list(
              list(
                source =   base64enc::dataURI(file = USER$cr_image_processed, mime = "image/png"),
                xref = "paper",
                yref = "paper",
                x = 0,
                y = 1,
                sizing = "stretch",
                #xanchor = "left", yanchor = "bottom",
                sizex = 1,
                sizey = 1,
                opacity = 1,
                layer = "below"
              )
              
            )
          )  %>%
          layout(
            xaxis = list(autorange = F, showgrid = F),
            yaxis = list(autorange = F, showgrid = F)
          ) %>%
          layout(margin = list(
            l = 0,
            r = 0,
            b = 0,
            t = 0,
            pad = 0
          ))  %>%
          # layout(autosize=T ) %>%
          
          config(
            displaylogo = FALSE,
            doubleClick = F,
            modeBarButtonsToRemove = c(
              "zoom2d",
              "pan2d",
              "select2d",
              "lasso2d",
              "autoScale2d",
              "resetScale2d",
              "hoverClosestCartesian",
              "hoverCompareCartesian",
              "toggleSpikelines",
              "zoomIn2d",
              "zoomOut2d"
            )
          )   %>%
          layout(dragmode = FALSE)
        
        
        for (i in 1:length(USER$cr_faceDetail)) {
          fig = fig %>%
            add_trace(
              key = i,
              x = x[[i]],
              y = y[[i]],
              type = 'scatter',
              fill = 'toself',
              fillcolor = 'rgba(147,112,219,0.1)',
              hoveron = 'fills',
              marker = list(color = 'rgba(147,112,219,0.1)'),
              line = list(color = '#3de6f2',
                          width = 2),
              text = sprintf("%s %s<br>%s<br>%s", scales::percent(confidence[[i]][[1]], scale = 1, accuracy = .01),'Celebrity'
                             ,name[[i]][[1]] ,url[[i]][[1]]),
              hoverinfo = 'text'
              
            )
        }
        
        cr_file_name = input$cr_file_input$name
        cr_img_list = NULL
        for (i in 1:(USER$cr_count_result)) {

          l_crop = paste0(
            as.character((x[[i]][[2]][[1]]) - (x[[i]][[1]][[1]])),
            'x',
            as.character((y[[i]][[1]][[1]]) - (y[[i]][[3]][[1]])),
            '+',
            as.character((x[[i]][[1]][[1]])),
            '+',
            as.character(imgHeight - (y[[i]][[1]][[1]]))
          )
          
          crop = image_crop(img, l_crop)
          img1 <- image_flatten(crop, "Modulate")
          
          img1 = crop
          
          img1 = image_scale(img1, "60")
          
          tmp_output_file = paste0('www/images/', 'tmp_', i, '_', cr_file_name)
          tmpfile =  magick::image_write(img1,
                                         path = tmp_output_file,
                                         format = "jpg",
                                         quality = 100)
          tmp_output_file = paste0('www/images/', 'tmp_', i, '_', cr_file_name)
          
          cr_img_list <- c(cr_img_list, tmp_output_file)

        }
        
        USER$cr_img_list = cr_img_list
        fig
        
      }
      else{
        fig
      }
      
    }
    
  })
  
  
  # . . 4.2.3 Calling AWS service through Python---------------------------------    
  
  
  observeEvent(input$cr_process,
               {
                 if (is.null(input$cr_file_input$name)) {
                   return()
                 }
                 show_modal_spinner(
                   spin = "fading-circle",
                   color = "#112446",
                   text = "Celebrity Recognition in progress....Please wait",
                   session = shiny::getDefaultReactiveDomain()
                 )
                 
                 # python file to invoke Celebrity Recognition  from AWS
                 
                 reticulate::py_run_file("celebrity_recognition.py")
                 
                 reticulate::py_run_string(
                   paste0(
                     "
photo = '",
                     input$cr_file_input$name   ,
                     "'
r_aws_access_key_id = '",
                     USER$r_aws_access_key_id   ,
                     "'
r_aws_secret_access_key = '",
                     USER$r_aws_secret_access_key   ,
                     "'

results = show_faces(photo,r_aws_access_key_id,r_aws_secret_access_key)
print(0)
print(results)

cr_image_result= results[0]
cr_count_result = results[1]
cr_faceDetail = results[2]
cr_json_file = results[3]

"
                   )
                 )
                 
                 USER$cr_image_processed = py$cr_image_result
                 USER$cr_count_result = py$cr_count_result
                 USER$cr_faceDetail = py$cr_faceDetail
                 USER$cr_json_file = py$cr_json_file

                 disable("cr_process")
                 remove_modal_spinner(session = getDefaultReactiveDomain())
                 
                 
               })
  
  
# . . 4.2.4 Image Gallery for celebrity recognition----------------------------    
  
  
  output$cr_slickr <- renderSlickR({

    if (is.null(USER$cr_img_list))
      return()
    img_list = USER$cr_img_list
    
    USER$cr_img_list_item = 1
    
    slick1 = slickR(img_list, slideId = 'cr1')
    
    
  })
  
  
  shiny::observeEvent(input$cr_slickr_current, {

    clicked_slide    = input$cr_slickr_current$.clicked
    relative_clicked    = input$cr_slickr_current$.relative_clicked
    active_slide     = input$cr_slickr_current$.slide

    USER$cr_img_list_item = as.numeric(input[["imageIndex"]]) 
  })
  
  
# . . 4.2.5 JSON file viewer for celebrity recognition details------------------    
  
  
  output$cr_jsed <- renderJsonedit({

    if (is.null(USER$cr_img_list)) {
      return()
    }
    
    i = USER$cr_img_list_item
    
    cr_details = USER$cr_faceDetail[[i]]
    cr_details[['BoundingBox']] = NULL
    
    jsonedit(
      cr_details,
      mode = "view",
      modes = c("code", "form", "text", "view")
      ,
      "change" = htmlwidgets::JS(
        'function(){
        console.log( event.currentTarget.pparentElement.editor.get() )
      }'
      )
    ) %>%
      onRender("function(el,cr_details,data) {this.editor.expandAll();}")
    
  })
  
  output$cr_count_result <- renderText({
    if(is.null(USER$cr_count_result)){return()}
    HTML(paste0('<br>' ,"<font color=\"#2b478c\">" ,"Celebritries detected: ",'<b>',USER$cr_count_result , "</b></font>" ))
  })
  
  
  

  
   
# . 4.3. Object Detection------------------------------------------------------ 
  
# . . 4.3.1 Reading Image file------------------------------------------------- 
  
  
  observe({
    if (is.null(input$od_file_input)) return()
    USER$od_base64 = dataURI(file = input$od_file_input$datapath, mime = "image/png")
    file.copy(input$od_file_input$datapath, input$od_file_input$name   , overwrite = TRUE)
    enable("od_process")
    USER$od_image_processed = NULL
    USER$od_count_result = NULL
  })
  
# . . 4.3.2 Displaying Image Pre Process---------------------------------------   
  
  output$od_imageview = renderUI({
    if(!is.null( USER$od_base64 )){
      
      if (!is.null(USER$od_image_processed)) {
        tags$img(src = paste0('./images/', as.character(USER$od_image_processed)))
      } else
      {  
      tags$div( tags$img(src= USER$od_base64)  )
      }
      
    }
  })
  

  
# . . 4.3.3 Calling AWS service through Python---------------------------------    

  observeEvent(input$od_process,
               {
                 if (is.null(input$od_file_input$name)) {
                   return()
                 }
                 show_modal_spinner(
                   spin = "fading-circle",
                   color = "#112446",
                   text = "Object/Scene detection in progress....Please wait",
                   session = shiny::getDefaultReactiveDomain()
                 )
                 
                 
                 reticulate::py_run_file("label_detection.py")
                 
                 reticulate::py_run_string(
                   paste0(
                     "
photo = '",
                     input$od_file_input$name   ,
                     "'
r_aws_access_key_id = '",
                     USER$r_aws_access_key_id   ,
                     "'
r_aws_secret_access_key = '",
                     USER$r_aws_secret_access_key   ,
                     "'

results = detect_labels(photo,r_aws_access_key_id,r_aws_secret_access_key)

od_image_result= results[0]
od_count_result = results[1]
od_objects = results[2]

"
                   )
                 )
                 
                 USER$od_image_processed = py$od_image_result
                 USER$od_count_result = py$od_count_result
                 USER$od_objects = base::as.data.frame(py$od_objects)
                 colnames(USER$od_objects) =  c("Label", "Frequency", "Prob")
                 disable("od_process")
                 remove_modal_spinner(session = getDefaultReactiveDomain())
                 shinyjs::show(id = "xx")

               })
  
  
  
# . . 4.3.4 Displaying Image Post Process--------------------------------------   
  
  
  output$od_count_result <- renderText({
    if (is.null(USER$od_count_result)) {
      return()
    }
    HTML(
      paste0(
        '<br>' ,
        "<font color=\"#2b478c\">" ,
        "Objects/Scenes detected: ",
        '<b>',
        USER$od_count_result ,
        "</b></font>"
      )
    )
  })
  
  
# . . 4.3.5 Treemap with objects and scenes detected---------------------------     
  
  output$od_treemap <- renderHighchart({
    if (is.null(USER$od_objects)) {
      return()
    }
    
    treemap <-
      hctreemap2(USER$od_objects,
                 c("Label"),
                 size_var = "Frequency",
                 color_var = "Prob") %>%
      hc_legend(enabled = TRUE) %>%
      hc_tooltip(
        pointFormat = "
                {point.name}<br>
                Objects: {point.value:,.0f}<br>
                Confidence: {point.colorValue:,.0f}%<br>"
      )
    treemap
    
  })
  
  

  
  
# . 4.4. Text in Image------------------------------------------------------ 
  
# . . 4.4.1 Reading Image file------------------------------------------------- 
  
  
  observe({
    if (is.null(input$ti_file_input)) return()
    USER$ti_base64 = dataURI(file = input$ti_file_input$datapath, mime = "image/png")
    file.copy(input$ti_file_input$datapath, input$ti_file_input$name   , overwrite = TRUE)
    enable("ti_process")
    USER$ti_image_processed = NULL
    USER$ti_count_result = NULL
  })
  
  # . . 4.4.2 Displaying Image Pre Process---------------------------------------   
  
  output$ti_imageview = renderUI({
    if(!is.null( USER$ti_base64 )){
      
      if (!is.null(USER$ti_image_processed)) {
        tags$img(src = paste0('./images/', as.character(USER$ti_image_processed)))
      } else
      {  
        tags$div( tags$img(src= USER$ti_base64)  )
      }
      
    }
  })
  
  
  
# . . 4.4.3 Calling AWS service through Python---------------------------------    
  
  observeEvent(input$ti_process,
               {
                 if (is.null(input$ti_file_input$name)) {
                   return()
                 }
                 show_modal_spinner(
                   spin = "fading-circle",
                   color = "#112446",
                   text = "Text in Image detection in progress....Please wait",
                   session = shiny::getDefaultReactiveDomain()
                 )
                 
                 
                 reticulate::py_run_file("text_in_image.py")
                 
                 reticulate::py_run_string(
                   paste0(
                     "
photo = '",
                     input$ti_file_input$name   ,
                     "'
r_aws_access_key_id = '",
                     USER$r_aws_access_key_id   ,
                     "'
r_aws_secret_access_key = '",
                     USER$r_aws_secret_access_key   ,
                     "'

results = show_text(photo,r_aws_access_key_id,r_aws_secret_access_key)

ti_image_result= results[0]
ti_count_result = results[1]
ti_faceDetail = results[2]
ti_lines_text = results[3]

"
                   )
                 )
                 
                 USER$ti_image_processed = py$ti_image_result
                 USER$ti_count_result = py$ti_count_result
                 USER$ti_faceDetail = py$ti_faceDetail
                 USER$ti_lines_text = py$ti_lines_text

                 disable("ti_process")
                 remove_modal_spinner(session = getDefaultReactiveDomain())
               })
  
  


  
  
# . . 4.4.4 JSON file viewer for text in image details---------------------------    
  
  
  output$ti_jsed <- renderJsonedit({

        if (is.null(USER$ti_count_result))  {
      return()
    }
    if (USER$ti_count_result==0)  {
      return()
    }
    
     ti_details = USER$ti_faceDetail
  #  cr_details[['BoundingBox']] = NULL
    
    jsonedit(
      ti_details,
      mode = "view",
      modes = c("code", "form", "text", "view")
      ,
      "change" = htmlwidgets::JS(
        'function(){
        console.log( event.currentTarget.pparentElement.editor.get() )
      }'
      )
    ) %>%
      onRender("function(el,ti_details,data) {this.editor.expandAll();}")
    
  })
  
  output$ti_count_result <- renderText({
    if (is.null(USER$ti_count_result)) {
      return()
    }
    HTML(
      paste0(
        '<br>' ,
        "<font color=\"#2b478c\">" ,
        "Words/Lines detected: ",
        '<b>',
        USER$ti_count_result ,
        "</b></font>"
      )
    )
  })
  
  
  output$ti_lines_text <- renderTable({
    if (is.null(USER$ti_lines_text)) {
      return()
    }
    if (!length(USER$ti_lines_text)>0) {
      return()
    }
    
    
    text.data <- as.data.frame(USER$ti_lines_text)
    
    colnames(text.data) = " "
    
    print(text.data)
    
  })
  
}

shinyApp(ui, server)
