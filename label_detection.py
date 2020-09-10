# -*- coding: utf-8 -*-
"""
Created on Tue Sep  8 15:36:45 2020

@author: SJVD
"""
import boto3
import io
from PIL import Image, ImageDraw
import  pandas as pd
import matplotlib.pyplot as plt


def detect_labels(photo, r_aws_access_key_id, r_aws_secret_access_key ):

    client=boto3.client('rekognition',  aws_access_key_id= r_aws_access_key_id , aws_secret_access_key=r_aws_secret_access_key, region_name='us-east-1')

    imageFile= photo 

    image=Image.open(imageFile)
    
    stream = io.BytesIO()
    image.save(stream,format=image.format ,dpi=(30, 30))
    
    image_binary = stream.getvalue()

    #Call DetectLabels 
    response = client.detect_labels(Image={'Bytes':image_binary},MinConfidence=65 ,
        MaxLabels=20 )
    
    
    
    imgWidth, imgHeight = image.size
    draw = ImageDraw.Draw(image)

    print('Detected labels for ' + photo) 

    print()   
    objects = list()
    for label in response['Labels']:
        count=0

        for instance in label['Instances']:
            count+=1
            box = instance['BoundingBox']
        
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
            
            points_header = (
            (left + width*.4,top-10 )
            )    
            
            draw.line(points, fill='#1335f2', width=2, joint='curve')
            
            draw.text(points_header, label['Name'], fill='blue' )
      
        x = lambda x: count if x>0 else 1
        objects.append((label['Name'],  x(count) , label['Confidence']  ))
                               
    fig=plt.imshow(image)
    
    
    plt.axis('off')
 
    fig.axes.get_xaxis().set_visible(False)
    fig.axes.get_yaxis().set_visible(False)
    
    output_image ='tmp_'+ imageFile
    plt.savefig('./www/images/' + output_image , bbox_inches='tight', transparent=True, pad_inches=0, dpi=200)
    
    results = [output_image,len(response['Labels']), pd.DataFrame(objects) ]
    
    return results