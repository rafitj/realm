'use strict';
var AWS = require('aws-sdk');
var https = require('https');
var s3 = new AWS.S3();
var bucketUrl = 'https://realm-files-bucket.s3.amazonaws.com/';

// Close dialog with the customer, reporting fulfillmentState of Failed or Fulfilled ("Thanks, your pizza will arrive in 20 minutes")
function close(sessionAttributes, fulfillmentState, message) {
    return {
        sessionAttributes,
        dialogAction: {
            type: 'Close',
            fulfillmentState,
            message,
        },
    };
}
 
 
// --------------- Events -----------------------

 
async function getImages(label) {
    AWS.config.update();
    
    var bucketUrl = 'https://realm-files-bucket.s3.amazonaws.com/';

    const S3 = new AWS.S3();
    
    S3.listObjects({
      Bucket: "realm-files-bucket",
    }, (err, data) => {
        data.Contents.forEach((row, i) => {
            var params = {
              Bucket: "realm-files-bucket", 
              Key: row.Key,
            };
            
            try {
              s3.getObjectTagging(params, function(_,data) {
                  data.TagSet.forEach((tag) => {
                      const url = bucketUrl + encodeURIComponent(row.Key);
                      if (tag.Value == label) {
                         console.log(url)
                      }
                    }
                 )
                })
            }
            catch(err) {
              console.log(err)
            }
             
            
        });
        return (data)
    });
  }
  
 
 
function dispatch(intentRequest, callback) {
    console.log(`request received for userId=${intentRequest.userId}, intentName=${intentRequest.currentIntent.name}`);
    const sessionAttributes = intentRequest.sessionAttributes;
    const slots = intentRequest.currentIntent.slots;
    const image = slots.Image
    getImages("sunset")
    callback(close(sessionAttributes, 'Fulfilled',
    {'contentType': 'PlainText', 'content': `Okay, here's your ${image}`}));
    
}
 

exports.handler = (event, context, callback) => {
    try {
        dispatch(event,
            (response) => {
                callback(null, response);
            });
    } catch (err) {
        callback(err);
    }
};
