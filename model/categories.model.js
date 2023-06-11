const db=require('../config/db');
const mongoose=require('mongoose');
const e = require('express');

const { Schema }=mongoose;

const categorieSchema= new Schema({
    foodType:{
        type:String,
        required:false,
    },
    imageUrl:{
        type:String,
        required:false,
    }
});

const CategoryModel=db.model('categories',categorieSchema);

module.exports=CategoryModel;