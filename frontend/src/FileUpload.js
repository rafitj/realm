import React from 'react';
import DropzoneComponent from 'react-dropzone-component';
import './dropzone.css';
import AWS from 'aws-sdk';

export default class Logo extends React.Component {

   
    render() {
        var componentConfig = {
            iconFiletypes: ['.jpg', '.png', '.gif'],
            showFiletypeIcon: true,
            postUrl: 'no-url'
        };
        var eventHandlers = { 
            addedfile: (file) => {
                AWS.config.update({
                  accessKeyId : 'AKIAINIMN3WMMBQOIZJA',
                  secretAccessKey : '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'
                });
                AWS.config.region = 'us-east-1';
                var bucket = new AWS.S3({params: {Bucket: 'realm-files-bucket'}});
                if (file) {
                    var params = {Key: `${file.name}`, ContentType: file.type, Body: file};
                    bucket.upload(params).on('httpUploadProgress', function(evt) {
                    console.log("Uploaded :: " + parseInt((evt.loaded * 100) / evt.total)+'%');
                  }).send(function(err, data) {
                    alert("File uploaded successfully.");
                  });
                }
            }
        }
       
        return  ( 
            <div>
                <DropzoneComponent 
                    config={componentConfig}
                    eventHandlers={eventHandlers}
                />;
            </div>
        ) 
        }
  }