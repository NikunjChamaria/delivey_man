const ImageModel = require('../model/image.model');

exports.download=async(req,res,nest)=>{
    try {
        const {ownerEmail,resName}=req.body;
        const result=await ImageModel.find({ownerEmail:ownerEmail,resName:resName},{});
        res.send(result);
    } catch (error) {
        throw error;
    }
}
