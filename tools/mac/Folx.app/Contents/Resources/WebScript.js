function getInputFieldsWithValues()
{
    var ids= "";
    var tags =  document.querySelectorAll('input[type=password]');
    for (var i = 0; i < tags.length; i++)
        ids +=tags[i].id+",";
    
    tags =  document.querySelectorAll('input[type=text]');
    for (var i = 0; i < tags.length; i++)
        ids +=tags[i].id+",";
    
    tags =  document.querySelectorAll('input[type=email]');
    for (var i = 0; i < tags.length; i++)
        ids +=tags[i].id+",";
    
    return ids;
}