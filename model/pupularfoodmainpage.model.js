const mongoose=require('mongoose');
const db=require('../config/db');
const e = require('express');

const { Schema }=mongoose;

const popularFoodMainPageSchema= new Schema({
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

const PopularFoodMainPageModel=db.model('popularMain',popularFoodMainPageSchema);

module.exports=PopularFoodMainPageModel;