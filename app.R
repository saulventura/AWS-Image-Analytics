# Initial required package 
#if (!require("dplyr")) install.packages("dplyr"); library(dplyr)
#setwd("C:\\Saul\\Portfolio\\ShinyAWS")

#options(shiny.trace = TRUE)  

# Setting working directory
#setwd(dirname(sys.frame(1)$ofile))
options(shiny.maxRequestSize = 300*1024^2)

#List all required packages - dplyr
packages = c("shiny", "shinydashboard", "shinyjs", "DT",  "readr", "shinycssloaders", "shinybusy", "reshape2",
             "shinyalert","ggplot2", "htmlwidgets","plotly","shinyWidgets", "tidyverse","dplyr",
             "plyr","stringr","lubridate")



# Install packages not yet installed
# installed_packages = packages %in% rownames(installed.packages())
# if (any(installed_packages == FALSE)) {
#    install.packages(packages[!installed_packages])
# }

#################################################################################
##                               LIBRARIES                                     ##   
#################################################################################


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
library(countrycode)
library(plyr)
library(dplyr)
library(plotly)

library(reticulate)
library(base64enc)


# Packages loading
# lapply(packages, library, character.only = TRUE) %>%  invisible()

# formatThousands <- JS(
#   "function(data) {",
#   "return (data / 1000).toFixed(1) + 'K'",
#   "}")


############################ menu


sidebar = dashboardSidebar(uiOutput("sidebarpanel") , collapsed = FALSE, disable = FALSE) 





l_title = ""

body <- dashboardBody(
    shinyjs::useShinyjs(),
    
    useShinyalert(),
    tags$head(
        tags$style(type = "text/css",
                   HTML("th { text-align: center; }")
        )
    ),
    
    tags$head(tags$style(HTML(
        '.myClass { 
        font-size: 21px;
        line-height: 50px;
        text-align: center;
        font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
        padding: 0 15px;
        overflow: hidden;
        color: white;
      }
    '))),
    tags$script(HTML(paste0('
      $(document).ready(function() {
        $("header").find("nav").append(\'<span class="myClass"> ', l_title ,'</span>\');
      })
     '))),
    
    tabItems(
        
        tabItem("dashboard", class = "active",
                
                
                
                fluidRow(
                    
                    column(width=6,
                           fluidRow(
                               box(width=12, collapsible = TRUE,  title="Image",status="primary",solidHeader = TRUE,
                                   # column(width=12,leafletOutput("fd_picture", width = '100%' ,height="500" )),
                                   
                                   fluidRow(   style='height:12vh',
                                               
                                               column(width=12,
                                                      fileInput(
                                                          inputId = "file_input",
                                                          label = "Drag and drop your Image here",
                                                          multiple = FALSE,
                                                          buttonLabel = list(icon("folder"),"Select File"),
                                                          accept = c('image/png', 'image/jpeg'),
                                                          placeholder = "No file selected"
                                                      )
                                               ) # column close
                                               
                                   ), #   fluidRow close
                                   
                                   fluidRow(
                                       column(width=12,
                                              
                                              tags$head(tags$style(
                                                  type="text/css",
                                                  "#imageview img {max-width: 100%; width: 100%; height: auto}"
                                              )),      
                                              
                                              uiOutput("imageview")
                                       ) # column close
                                       
                                   ) #   fluidRow close
                               )# box close
                           ) #   fluidRow close
                    ), # column close
                    
                    
                    column(width=6,
                           fluidRow( 
                               
                               box(width=12, collapsible = TRUE, title="Results", status="primary",solidHeader = TRUE,
                                   
                                   fluidRow(   style='height:12vh',
                                               
                                               column(width=12,
                                                      br(),
                                                      disabled(actionButton(inputId = "fd_process", label = "Process", icon = icon("caret-square-right"))),
                                                      htmlOutput("fd_text_results")
                                                      
                                               ) # column close
                                               
                                   ), #   fluidRow close
                                   
                                   fluidRow(
                                       column(width=12,
                                              
                                              tags$head(tags$style(
                                                  type="text/css",
                                                  "#image_processed img {max-width: 100%; width: 100%; height: auto}"
                                              )),
                                              # imageOutput('image_processed')
                                              uiOutput('image_processed')
                                              
                                       ) # column close
                                       
                                   ) #   fluidRow close
                                   
                               )# box close
                               
                           ) #   fluidRow close
                    ) # column close                          
                    
                    
                    
                ) #fluidrow    
                
                
                
        ),
        
        
        
        tabItem("about",
                tags$div(
                    tags$h4("MachineHack - AWS Hackathon"), 
                    "This app was built using R Shiny and Python.",tags$br(),
                    "",tags$br(),
                    # tags$a(href="https://github.com/CSSEGISandData/COVID-19", "GitHub JHU CSSE account"),
                    tags$br(),
                    tags$h5("Team"),
                    tags$ul(
                        tags$li("Saul Ventura")
                    )
                )
        )
        
    ) #tabitems close
    
    
)




header = dashboardHeader(
    title = 'AWS Image Analytics' )






ui = dashboardPage(header, sidebar, body)


#################################################################################
##                               SERVER                                        ##   
#################################################################################



server = function(input, output, session) {    
    
    USER = reactiveValues(positions  = NULL, fd_image= NULL ,  fd_image_full_path = NULL , fd_image_processed= NULL, fd_path = NULL,fd_text_results = NULL  )
    
    
    
    #################################################################################
    ##                               MENU CREATION                                 ##   
    #################################################################################
    
    
    output$sidebarpanel = renderUI({
        
        
        dashboardSidebar(
            
            
            sidebarMenu(
                br(),
                menuItem( strong("Face Detection"), tabName = "dashboard", icon = icon("meh")) 
                
                #  menuItem(strong("FORECASTING"), tabName = "forecast", icon = icon("chart-line")) ,
                
                # br(), br(), br(),br(), br(), br(),
                #  hr(),
                # menuItem(strong("About"), tabName = "about", icon = icon("question")),
                #   hr()
            )
            
        )
        
        
        
        
        
        
        
    })    
    
    
    
    
    #################################################################################
    ##                               DATA LOAD                                     ##   
    #################################################################################
    
    
    
    
    base64 <- reactive({
        inFile <- input[["file_input"]]
        
        if(!is.null(inFile)){
            
            USER$fd_image = as.character(input$file_input$name)
            USER$fd_path = inFile$datapath
            
            dataURI(file = inFile$datapath, mime = "image/png")
            
        }
    })
    
    output$imageview <- renderUI({
        if(!is.null(base64())){
            tags$div(
                tags$img(src= base64())#, width="100%", height="100%")#,
                # style = "width: 400px;"
                # style = "width: 50%;"
            )
        }
        #print('im')
        #print(base64())
        
    })
    
    
    
    
    observe({
        req(input$file_input)
        
        
       # USER$fd_image_full_path = paste0("C:\\Saul\\Portfolio\\AWSImageAnalytics\\",USER$fd_image)
        USER$fd_image_full_path = paste0("",USER$fd_image)
        
        
        file.copy(input$file_input$datapath, USER$fd_image_full_path   , overwrite = TRUE)
        
        print(USER$fd_image_full_path)
        print(input$file_input$datapath)
        print(USER$fd_image)
        
        enable("fd_process")
        USER$fd_image_processed =NULL
        USER$fd_text_results =NULL
    })
    
    
    
    #################################################################################
    ##                               PROCESS                                       ##   
    #################################################################################
    
    
    
    
    
    
    observeEvent(input$fd_process,{
        print(1000)
        if(is.null(USER$fd_image)){return()}
        
        print(USER$fd_image)
        show_modal_spinner(spin = "fading-circle", color = "#112446",text = "Face detection in progress....Please wait", session = shiny::getDefaultReactiveDomain())
        print(1009)
        
        reticulate::py_run_string(paste0( "
import boto3
import io
from PIL import Image, ImageDraw, ExifTags, ImageColor
from IPython.display import display
import numpy as np
import matplotlib.pyplot as plt

def show_faces(photo,bucket):
     
   # session = boto3.Session(
    #aws_access_key_id=settings.AWS_SERVER_PUBLIC_KEY,
   # aws_secret_access_key=settings.AWS_SERVER_SECRET_KEY)
   
   AWS_ACCESS_KEY_ID = os.environ.get('AWS_ACCESS_KEY_ID', '') 
   AWS_SECRET_ACCESS_KEY = os.environ.get('AWS_SECRET_ACCESS_KEY', '')

    
    ##print(1)
    #client=boto3.client('rekognition', region_name='us-east-1')
    client=boto3.client('rekognition',  aws_access_key_id=AWS_ACCESS_KEY_ID, aws_secret_access_key=AWS_SECRET_ACCESS_KEY, region_name='us-east-1')

    imageFile= photo 

    #image=Image.open(stream)
    image=Image.open(imageFile)
    
    stream = io.BytesIO()
    image.save(stream,format='JPEG' ,dpi=(30, 30))
    image_binary = stream.getvalue()
        # Load image from S3 bucket
    #s3_connection = boto3.resource('s3')
    #s3_object = s3_connection.Object(bucket,photo)
    #s3_response = s3_object.get()

    #stream = io.BytesIO(s3_response['Body'].read())
    #image=Image.open(stream)
    
        #Call DetectFaces 
   # response = client.detect_faces(Image={'S3Object': {'Bucket': bucket, 'Name': photo}},
   #     Attributes=['ALL'])
        
   # with open(imageFile, 'rb') as image:
     #   response = client.detect_faces(Image={'Bytes': image.read()}  )
    #response = client.detect_faces(Image={'Bytes': image.read()}  )   
    
    response = client.detect_faces(Image={'Bytes':image_binary} )
        
        
    imgWidth, imgHeight = image.size  
    draw = ImageDraw.Draw(image)  
                    

    # calculate and display bounding boxes for each detected face       
    print('Detected faces for ' + imageFile)    
    for faceDetail in response['FaceDetails']:
        #print('The detected face is between ' + str(faceDetail['AgeRange']['Low']) 
         #     + ' and ' + str(faceDetail['AgeRange']['High']) + ' years old')
        
        box = faceDetail['BoundingBox']
        left = imgWidth * box['Left']
        top = imgHeight * box['Top']
        width = imgWidth * box['Width']
        height = imgHeight * box['Height']
                

        points = (
            (left,top),
            (left + width, top),
            (left + width, top + height),
            (left , top + height),
            (left, top)

        )
        draw.line(points, fill='#24f0f0', width=4)

        # Alternatively can draw rectangle. However you can't set line width.
        #draw.rectangle([left,top, left + width, top + height], outline='#00d400') 

    #image.show()
    plt.imshow(image)
    
    
    plt.axis('off')
   # plt.savefig('C:/Saul/Portfolio/AWSImageAnalytics/www/images/' +'tmp_'+ imageFile, bbox_inches='tight',transparent=True, pad_inches=0, dpi=200)
    plt.savefig('/www/images/' +'tmp_'+ imageFile, bbox_inches='tight',transparent=True, pad_inches=0, dpi=200)
    img1='tmp_'+ imageFile
    
    
    #plt.show()
    
    #display(image)

    #plt.imshow(image)
    
    #fig1 = plt.gcf()
    #fig1.savefig('abcdef.jpg', dpi=600)
    #plt.savefig(plt.imshow(image), format='jpg')
    
    #image(image, image.format)
    
    return  img1 , len(response['FaceDetails'])
   # print(100)


    
"))
        
        
        
        reticulate::py_run_string(paste0( "
#def main_function(photo):

  #  print(101)
  #  bucket='samplesj'
  #  photo='avengers.jpg'
 #   print(102)
   # results = show_faces(photo,bucket)
    #photo1 = results[0]
    #faces_count = results[1]
    
   # print('faces detected: ' + str(faces_count))
 #   return results

#if __name__ == '__main__':

bucket='samplesj'

photo = '", USER$fd_image   , "'
    
#photo='avengers.jpg'
#print(102)
results = show_faces(photo,bucket)
    
#print(103)
#results = main('avengers.jpg')
photo1= results[0]
faces_count = results[1]
    #photo1='avengers.jpg'
    
")) 
        
        print(11)
        print(py$photo1)
        USER$fd_image_processed= py$photo1
        USER$fd_text_results = py$faces_count
        
        disable("fd_process")
        
        remove_modal_spinner(session = getDefaultReactiveDomain())
        
        
    })
    
    
    
    
    
    
    
    
    
    output$image_processed1 = renderImage({
        # print(12)
        #  print(USER$fd_image_processed)
        #  print(13)
        #  print(USER$fd_path)
        #  print(20)
        # print(input$file_input$datapath) 
        # print(paste0('C:/Saul/Portfolio/ShinyAWS/www/images/',py$photo1))
        
        if(1==2){
            ##tags$div(
            ## tags$img(src= paste0('C:/Saul/Portfolio/ShinyAWS/www/images/',py$photo1)  , width="100%"),
            # style = "width: 400px;"
            ##  style = "width: 100%;"
            ## )
            #list(src = paste0('C:/Saul/Portfolio/ShinyAWS/www/images/', as.character(py$photo1)) ,  alt = "This is alternate text"   )
            list(src = paste0('/www/images/', as.character(py$photo1)) ,  alt = "This is alternate text"   )
            
        }
    }, deleteFile = FALSE)
    
    output$image_processed <- renderUI({
        if (!is.null(USER$fd_image_processed)){
            tags$img(src = paste0('images/',as.character(USER$fd_image_processed)))
        }
    })
    
    
    output$fd_text_results <- renderText({
        
        if(is.null(USER$fd_text_results)){return()}
        HTML(paste0('<br>' ,"<font color=\"#2b478c\">" ,"Faces detected: ",'<b>',USER$fd_text_results , "</b></font>" ))
        
        
    })
    
    
    
}

shinyApp(ui, server)
