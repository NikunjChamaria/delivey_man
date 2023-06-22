
const AddressModel=require('../model/adress.model');

class AddressService{
    static async postData(useremail,address,lat,long){
        try {
            const data=new AddressModel({useremail,address,lat,long});
            return await data.save();
        } catch (error) {
            throw error;
        }
    }
}

module.exports=AddressService;