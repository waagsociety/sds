function(doc)
{
	emit(doc['_id'],{'comment' : doc['commment']});
}
