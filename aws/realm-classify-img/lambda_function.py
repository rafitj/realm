import json
import boto3
import base64


sagemaker_url = "https://runtime.sagemaker.us-east-1.amazonaws.com/endpoints/realm-image-classifier/invocations"



def lambda_handler(event, context):
    image = base64.b64decode(event)
    
    runtime = boto3.Session().client(service_name='sagemaker-runtime', region_name='us-east-1')
    response = runtime.invoke_endpoint(EndpointName=sagemaker_url, ContentType='application/x-image', Body=image)
    probs = response['Body'].read().decode() 

    probs = ast.literal_eval(probs) 
    probs = np.array(probs)

    topk_indexes = probs.argsort() 
    topk_indexes = topk_indexes[::-1][:topk] 

    topk_categories = []
    for i in topk_indexes:
       topk_categories.append((i+1, probs[i]))
    
    # response = runtime.invoke_endpoint(EndpointName="realm-image-classifier",
    #                                   ContentType='image/png',
    #                                   Body=event)
                                       
    # result = json.loads(response['Body'].read().decode())
    
    # pred = int(result['predictions'])

    
    # TODO implement
    return {
        'statusCode': 200,
        'body': str(topk_categories)
    }
