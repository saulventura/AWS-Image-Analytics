# -*- coding: utf-8 -*-
"""
Created on Tue Sep  8 17:44:29 2020

@author: SJVD
"""
import boto3
import io, json
import matplotlib.pyplot as plt
from PIL import Image, ImageDraw


def show_faces(photo, r_aws_access_key_id, r_aws_secret_access_key ):

    client=boto3.client('rekognition',  aws_access_key_id= r_aws_access_key_id , aws_secret_access_key=r_aws_secret_access_key, region_name='us-east-1')

    imageFile= photo 

    image=Image.open(imageFile)
    
    stream = io.BytesIO()
    image.save(stream,format=image.format ,dpi=(30, 30))
    
    image_binary = stream.getvalue()

    #Call DetectFaces 
    response = client.recognize_celebrities(Image={'Bytes':image_binary} )
        
    imgWidth, imgHeight = image.size  
    draw = ImageDraw.Draw(image)  
                    

    # calculate and display bounding boxes for each detected face       
    print('Detected faces for ' + imageFile)    
    
    coordinates = list()
    
    for celebrity  in response['CelebrityFaces']:

        box = celebrity['Face']['BoundingBox']
        left = imgWidth * box['Left']
        top = imgHeight * box['Top']
        width = imgWidth * box['Width']
        height = imgHeight * box['Height']
        
     
        
        #coordinates.append( (x1,y1,x2,y2) )
                
                
        points = (
            (left,top),
            (left + width, top),
            (left + width, top + height),
            (left , top + height),
            (left, top)

        )
        
        coordinates.append( points )
        
        draw.line(points, fill='#24f0f0', width=4)

        # Alternatively can draw rectangle. However you can't set line width.
        #draw.rectangle([left,top, left + width, top + height], outline='#00d400') 

    fig=plt.imshow(image)
    
    
    plt.axis('off')
 
    fig.axes.get_xaxis().set_visible(False)
    fig.axes.get_yaxis().set_visible(False)
    
    # Serializing json  
    json_results = json.dumps(response['CelebrityFaces'], indent=4)#, sort_keys=True)
    #print(json_results)
    
  
 
    
    output_image =  imageFile #'tmp_'+ imageFile
    plt.savefig('./www/images/' + output_image , bbox_inches='tight', transparent=True, pad_inches=0, dpi=200)
    
    results = [output_image ,len(response['CelebrityFaces']), response['CelebrityFaces'] ,json_results ]
    
    return results