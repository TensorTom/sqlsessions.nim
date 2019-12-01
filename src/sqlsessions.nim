import sysrandom
import jester
import db_mysql
import tables
import strutils
import strtabs
import strformat
import times
#import math

var configData = newStringTable(modeCaseInsensitive)

configData["host"] = "localhost"
configData["port"] = "6379"
configData["expiresMinutes"] = $(60 * 24 * 2) #sessions expire in two days

type
    TSession* = object
      enabled: bool
      
var session*: TSession


proc get_expire():string = 
    let seconds = parseInt(configData["expiresMinutes"]) * 60
    let now = getTime()
    let epoch = toUnix(now).int
    let future = epoch + seconds
    return fmt"{future}"


proc gen_session_id():string =
    var sid:string = $(getRandomString(256))
    #sid.delete(sid.len-1, sid.len-1)
    return sid


proc set_session(request: Request):string =
    session.enabled = true
    var sessionId = gen_session_id()
    let exp = get_expire()
    echo exp
    #setCookie(name="sessionId", value=sessionId, expires=exp)
    return sessionId


proc get_session(request: Request):string =
    var sessionId:string

    if request.cookies.hasKey("sessionId"):
        return request.cookies["sessionId"]
    return nil


proc increment_session(session_id: string):string =
    discard """pass"""


proc init_session(request: Request):string =
    let current_session = get_session(request)
    if current_session != nil:
        return current_session
    return set_session(request)