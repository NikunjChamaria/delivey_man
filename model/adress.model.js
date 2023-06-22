const db=require('../config/db');
const mongoose=require('mongoose');

const { Schema }=mongoose;


const AddressSchema=new Schema({
    useremail:String,
    address:String,
    lat:Number,
    long:Number,
    isCurrent:{
        type:Boolean,
        default:true
    }
});



const AddressModel=db.model('address',AddressSchema);

module.exports=AddressModel;