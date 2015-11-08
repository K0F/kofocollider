/*

Kofocollider interface to SuperCollider written in processing and using OpenObject
Copyright (C) 2015 Krystof Pesek

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

class Connection{
  Envelope env;
  Editor ed;
 
  PVector dest,target;


  int field;
  boolean done = false;

  Connection(Envelope _env){
    env = _env;
  }

  //called form mouse events
  void connectTo(Editor _ed,int _field){
    if(_ed==ed&&_field==field)
    connections.remove(this);

    ed = _ed;
    field = _field;
    done = true;
    println("connected to field "+field);

  }
 
  void draw(){
    stroke(255,127);
    if(!done){
      dest = new PVector(env.pos.x+5,env.pos.y+env.dim.y+5);
      target = new PVector(mouseX,mouseY);

    }else{
      
      dest = new PVector(env.pos.x+5,env.pos.y+env.dim.y+5);
      target = new PVector(ed.field_rozpal[field]+ed.pos.x+5,ed.pos.y-20-4);

      sendVal();
    }
    
    stroke(255,env.output*255);
    line(dest.x,dest.y,target.x,target.y);
  }

  void sendVal(){
    ed.vals[field]=env.output;
  }
}
