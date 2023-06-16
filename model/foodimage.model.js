const db=require('../config/db');
const mongoose=require('mongoose');
const e = require('express');

const { Schema }=mongoose;

const foodImageSchema=new Schema({
    image:{
        data:Buffer,
        contentType:String
    },
    ownerEmail:String,
    resName:String,
    foodName:String
});



const FoodImageModel=db.model('imagefood',foodImageSchema);

module.exports=FoodImageModel;