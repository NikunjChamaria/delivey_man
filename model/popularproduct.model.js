const mongoose=require('mongoose');
const db=require('../config/db');
const e = require('express');

const { Schema }=mongoose;

const popularProductMainPageSchema= new Schema({
    name:{
        type:String,
        required:true,
    },
    imageUrl:{
        type:String,
        required:true,
    },
    rating:{
        type:String,
        required:true,
    
    }
});

const PopularProductMainPageModel=db.model('popularProductMain',popularProductMainPageSchema);

module.exports=PopularProductMainPageModel;