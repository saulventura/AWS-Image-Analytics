import boto3
import io, json
import matplotlib.pyplot as plt
from PIL import Image, ImageDraw

def show_text(photo, r_aws_access_key_id, r_aws_secret_access_key ):

    client=boto3.client('rekognition',  aws_access_key_id= r_aws_access_key_id , aws_secret_access_key=r_aws_secret_access_key, region_name='us-east-1')

    imageFile= photo 

    image=Image.open(imageFile)
    
    stream = io.BytesIO()
    image.save(stream,format=image.format ,dpi=(30, 30))
    
    image_binary = stream.getvalue()

    #Call DetectText 
    
    response = client.detect_text(Image={'Bytes':image_binary} )    
    
   
    imgWidth, imgHeight = image.size
    draw = ImageDraw.Draw(image)

    print('Detected text for ' + photo) 

    print()   
    
    coordinates = list()
    lines_text  = list()
    
    for text  in response['TextDetections']:

        

        if (text['Type']=='LINE'):
            lines = text['DetectedText']
            lines_text.append( lines )
    
        
        if (text['Type']=='WORD'):
            box = text['Geometry']['BoundingBox']
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

            draw.line(points, fill='#24f0f0', width=2)

        # Alternatively can draw rectangle. However you can't set line width.
        #draw.rectangle([left,top, left + width, top + height], outline='#00d400') 

    fig=plt.imshow(image)
    
    
    plt.axis('off')
 
    fig.axes.get_xaxis().set_visible(False)
    fig.axes.get_yaxis().set_visible(False)
    
    # Serializing json  
    #json_results = json.dumps(response['TextDetections'], indent=4)#, sort_keys=True)
    #print(json_results)
    
    
    output_image =  imageFile #'tmp_'+ imageFile
    plt.savefig('./www/images/' + output_image , bbox_inches='tight', transparent=True, pad_inches=0, dpi=200)
    
    results = [output_image ,len(response['TextDetections']) ,response['TextDetections'],lines_text ]
    
    return results