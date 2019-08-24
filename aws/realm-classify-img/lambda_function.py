import os
import io
import boto3
import json
import PIL

    
# grab environment variables
runtime= boto3.client('runtime.sagemaker')

def lambda_handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))
    
    data = json.loads(json.dumps(event))
    payload = data['data']
    
    response = runtime.invoke_endpoint(EndpointName="realm-image-classifier",
                                       ContentType='text/csv',
                                       Body=payload)
    print(response)
    result = json.loads(response['Body'].read().decode())
    print(result)
    pred = int(result['predictions'][0]['predicted_label'])
    predicted_label = 'M' if pred == 1 else 'B'
    
    return {
        'statusCode': 200,
        'body': json.dumps(predicted_label)
    }
