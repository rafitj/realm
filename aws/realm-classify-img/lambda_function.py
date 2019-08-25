import os
import io
import boto3
import json
import requests
import pandas as pd
import requests

sagemaker_url = "https://runtime.sagemaker.us-east-1.amazonaws.com/endpoints/realm-image-classifier/invocations"
# grab environment variables
runtime = boto3.client('runtime.sagemaker')

def lambda_handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))
    
    data = json.loads(json.dumps(event))
    url = data['data']

    f = requests.get(url)
    # separate each line
    newf = f.text.splitlines()
    # create pandas dataframe
    df = pd.DataFrame([x.split(",") for x in newf])

    img_file = {'media': df}
    # requests.post(sagemaker_url, files=img_file)

    response = runtime.invoke_endpoint(EndpointName="realm-image-classifier",
                                       ContentType='text/csv',
                                       Body=img_file)
    print(response)
    result = json.loads(response['Body'].read().decode())
    print(result)
    pred = int(result['predictions'][0]['predicted_label'])
    predicted_label = 'M' if pred == 1 else 'B'
    
    return {
        'statusCode': 200,
        'body': json.dumps(predicted_label)
    }
