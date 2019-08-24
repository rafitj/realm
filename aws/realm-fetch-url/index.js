'use strict';
var AWS = require('aws-sdk');
var dynamodb = new AWS.DynamoDB();
 
function fetchURLs(){
    return new Promise((resolve, reject) => {
         var params = {
            TableName: "realm-img-urls",
         }
        
         dynamodb.scan(params, function(err, data) {
               if (err) {
                   console.log(err, err.stack); // an error occurred
                    reject();   
               }
               else  {
               }// successful response
               resolve(data.Items.map(row=>row.url.S));
         })
        
    })
}

 
exports.handler = async (event) => {
    // TODO implement
    const res =  await fetchURLs();
    const response = {
        statusCode: 200,
        body: JSON.stringify(res),
    };
    return response;
};
