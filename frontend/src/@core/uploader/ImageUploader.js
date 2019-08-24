import React from 'react';
import { Upload, Icon, Modal } from 'antd';
import AWS from "aws-sdk";

function getBase64(file) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = () => resolve(reader.result);
    reader.onerror = error => reject(error);
  });
}

const props = {
  customRequest({
    file,
    onError,
    onProgress,
    onSuccess
  }) {
    AWS.config.update({
      accessKeyId : 'AKIAINIMN3WMMBQOIZJA',
      secretAccessKey : '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'
    });

    const S3 = new AWS.S3();

    const objParams = {
      Bucket: "realm-files-bucket",
      Key: file.name,
      Body: file,
      ContentType: file.type,
      ACL: "public-read-write"
    };

    S3.putObject(objParams)
      .on("httpUploadProgress", function({ loaded, total }) {
        onProgress(
          {
            percent: Math.round((loaded / total) * 100)
          },
          file
        );
      })
      .send(function(err, data) {
        if (err) {
          onError();
        } else {
          onSuccess(data.response, file);
        }
      });
  }
};

export class ImageUploader extends React.Component {
  state = {
    previewVisible: false,
    previewImage: '',
    fileList: [],
  };

  handleCancel = () => this.setState({ previewVisible: false });

  handlePreview = async file => {
    if (!file.url && !file.preview) {
      file.preview = await getBase64(file.originFileObj);
    }

    this.setState({
      previewImage: file.url || file.preview,
      previewVisible: true,
    });
  };

  handleChange = ({ fileList }) => this.setState({ fileList });
  
  constructor(props) {
    super(props);
    this.fetchImages();
  }

  async fetchImages() {
    AWS.config.update({
      accessKeyId : 'AKIAINIMN3WMMBQOIZJA',
      secretAccessKey : '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'
    });
    
    var bucketUrl = 'https://realm-files-bucket.s3.amazonaws.com/';

    const S3 = new AWS.S3();
    S3.listObjects({
      Bucket: "realm-files-bucket",
    }, (err, data) => {
      if (!data || !data.Contents) {
        return null;
      }
      const photos = data.Contents.map((row, index) => {
        const { Key } = row;
        const url = bucketUrl + encodeURIComponent(Key);

        return {
          uid: index,
          name: Key,
          status: 'done',
          url,
        };
      });
      
      this.setState({
        fileList: photos
      });
    });
  }

  render() {
    const { previewVisible, previewImage, fileList } = this.state;
    const uploadButton = (
      <div>
        <Icon type="plus" />
        <div className="ant-upload-text">Upload</div>
      </div>
    );
    return (
      <div className="clearfix">
        <Upload
          {...props}
          listType="picture-card"
          fileList={fileList}
          multiple
          onPreview={this.handlePreview}
          onChange={this.handleChange}
        >
          {uploadButton}
        </Upload>
        <Modal visible={previewVisible} footer={null} onCancel={this.handleCancel}>
          <img alt="example" style={{ width: '100%' }} src={previewImage} />
        </Modal>
      </div>
    );
  }
}