function(newDoc,oldDoc,userCtx)
{
	//dsl
	function require(beTrue,message)
	{
		if(!beTrue) throw({forbidden :message});
	};

	if(newDoc.type == "taxi_data")
	{
		//validation logic
		require("comment","You may not leave an empty comment");
	}
}
