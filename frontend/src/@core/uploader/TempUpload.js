import React from 'react';
import { Upload, Button, Icon, message } from 'antd';
import reqwest from 'reqwest';
import AWS from "aws-sdk";

export class TempUpload extends React.Component {
  state = {
    fileList: [],
    uploading: false,
  };

  handleUpload = () => {
    const { fileList } = this.state;
    const formData = new FormData();
    fileList.forEach(file => {
      formData.append('files[]', file);
    });

    this.setState({
      uploading: true,
    });

    AWS.config.update({
        accessKeyId : 'AKIAINIMN3WMMBQOIZJA',
        secretAccessKey : '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'
    });
  
    const lambda = new AWS.Lambda({ region: "us-east-1" });

    const pullParams = {
        FunctionName : 'realm-img-classifier',
        InvocationType : 'RequestResponse',
        LogType : 'None',
        Payload: JSON.stringify({
            // data: JSON.stringify(photoImg)
        })
    };
  
    lambda.invoke(pullParams, function(error, data) {
        console.log(error, data);
        if (error) {
            throw new Error(error);
        } else {
            console.log(data);
            // pullResults = JSON.parse(data.Payload);
        }
    });

    // You can use any AJAX library you like
    reqwest({
      url: 'https://www.mocky.io/v2/5cc8019d300000980a055e76',
      method: 'post',
      processData: false,
      data: formData,
      success: () => {
        this.setState({
          fileList: [],
          uploading: false,
        });
        message.success('upload successfully.');
      },
      error: () => {
        this.setState({
          uploading: false,
        });
        message.error('upload failed.');
      },
    });
  };

  render() {
    const { uploading, fileList } = this.state;
    const props = {
      onRemove: file => {
        this.setState(state => {
          const index = state.fileList.indexOf(file);
          const newFileList = state.fileList.slice();
          newFileList.splice(index, 1);
          return {
            fileList: newFileList,
          };
        });
      },
      beforeUpload: file => {
        this.setState(state => ({
          fileList: [...state.fileList, file],
        }));
        return false;
      },
      fileList,
    };

    return (
      <div>
        <Upload {...props}>
          <Button>
            <Icon type="upload" /> Select File
          </Button>
        </Upload>
        <Button
          type="primary"
          onClick={this.handleUpload}
          disabled={fileList.length === 0}
          loading={uploading}
          style={{ marginTop: 16 }}
        >
          {uploading ? 'Uploading' : 'Start Upload'}
        </Button>
      </div>
    );
  }
}