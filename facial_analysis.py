import boto3, io, json
from PIL import Image, ImageDraw
import matplotlib.pyplot as plt



def show_faces(photo, r_aws_access_key_id, r_aws_secret_access_key ):

    client=boto3.client('rekognition',  aws_access_key_id= r_aws_access_key_id , aws_secret_access_key=r_aws_secret_access_key, region_name='us-east-1')

    imageFile= photo

    image=Image.open(imageFile)

    stream = io.BytesIO()
    image.save(stream,format=image.format ,dpi=(30, 30))

    image_binary = stream.getvalue()

    #Call DetectFaces
    response = client.detect_faces(Image={'Bytes':image_binary},Attributes=['ALL'] )

    imgWidth, imgHeight = image.size
    #draw = ImageDraw.Draw(image)


    # calculate and display bounding boxes for each detected face
    print('Detected faces for ' + imageFile)
    
    
    '''
    for faceDetail in response['FaceDetails']:

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
        
        coordinates.append( points )
        draw.line(points, fill='#24f0f0', width=4)

        # Alternatively can draw rectangle. However you can't set line width.
        #draw.rectangle([left,top, left + width, top + height], outline='#00d400')
    '''
    '''
    fig=plt.imshow(image)


    plt.axis('off')

    fig.axes.get_xaxis().set_visible(False)
    fig.axes.get_yaxis().set_visible(False)
    '''


    # Serializing json
    #json_results = json.dumps(response['FaceDetails'], indent=4)#, sort_keys=True)
    # print(json_results)

    output_image =  imageFile  #'tmp_'+ imageFile
    plt.savefig('./www/images/' + output_image , bbox_inches='tight', transparent=True, pad_inches=0, dpi=200)

    results = [output_image,len(response['FaceDetails'])  , response['FaceDetails'] ]#,json_results  ]

    return results