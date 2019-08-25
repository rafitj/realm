import os
import io
import boto3
import json
from PIL import Image
from numpy import array, moveaxis, indices, dstack
from pandas import DataFrame


def convert_to_csv(data):
    image = Image.open(data)
    pixels = image.convert("RGB")
    rgbArray = array(pixels.getdata()).reshape(image.size + (3,))
    indicesArray = moveaxis(indices(image.size), 0, 2)
    allArray = dstack((indicesArray, rgbArray)).reshape((-1, 5))


    df = DataFrame(allArray, columns=["y", "x", "red","green","blue"])
    print(df.head())
    df.to_csv("data.csv",index=False)
    return df

# grab environment variables
runtime= boto3.client('runtime.sagemaker')

def lambda_handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))
    
    data = json.loads(json.dumps(event))
    payload = data['data']
    img = convert_to_csv(payload)
    response = runtime.invoke_endpoint(EndpointName="realm-image-classifier",
                                       ContentType='text/csv',
                                       Body=img)
    print(response)
    result = json.loads(response['Body'].read().decode())
    print(result)
    pred = int(result['predictions'][0]['predicted_label'])
    predicted_label = 'M' if pred == 1 else 'B'
    
    return {
        'statusCode': 200,
        'body': json.dumps(predicted_label)
    }
