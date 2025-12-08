
function parseEnvList ( listString,  delimiter )
{
    if ( !listString ) return []

    return listString.split(  delimiter  ).map( item => item.trim() )
}


const ALLOWED_USERS = parseEnvList(  process.env.ALLOWED_USERS  ,  ',' ) ;

if ( ALLOWED_USERS.length > 0 ) console.log('Users loaded successfully')