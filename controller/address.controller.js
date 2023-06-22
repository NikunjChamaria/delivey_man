const AddressModel = require("../model/adress.model");
const AddressService = require("../services/address.services");


exports.postAddress=async(req,res,next)=>{
    try {
        const {useremail,address,lat,long}=req.body;
        const success1=await AddressModel.findOneAndUpdate({useremail:useremail,isCurrent:true},{isCurrent:false});
        const success=await AddressService.postData(useremail,address,lat,long);
        res.status(200).json({status:true,token:"yo"});
    } catch (error) {
        throw error;
    }
}
exports.getAddress=async(req,res,next)=>{
    try {
        const {useremail}=req.body;
        const result=await AddressModel.find({useremail:useremail},{_id:0,__v:0});
        res.send(result);
    } catch (error) {
        throw error;
    }
}
exports.setCurrent=async(req,res,next)=>{
    const {useremail,address}=req.body;
    const success1=await AddressModel.findOneAndUpdate({useremail:useremail,isCurrent:true},{isCurrent:false});
    const success=await AddressModel.findOneAndUpdate({useremail:useremail,isCurrent:false,address:address},{isCurrent:true});
    res.status(200).json({status:true,token:"yo"});
}

exports.getCurrent=async(req,res,next)=>{
    const {useremail}=req.body;
    const result=await AddressModel.find({useremail:useremail,isCurrent:true});
    res.send(result);
}