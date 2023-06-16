const db=require('../config/db');
const mongoose=require('mongoose');
const e = require('express');

const { Schema }=mongoose;

const imageSchema=new Schema({
    image:{
        data:Buffer,
        contentType:String
    },
    ownerEmail:String,
    resName:String
});



const ImageModel=db.model('image',imageSchema);

module.exports=ImageModel;