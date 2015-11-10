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

import oscP5.*;
import netP5.*;
import java.io.*;

OscP5 osc;
NetAddress sc;

//Boid boid;

ArrayList editors;
Timeline timeline;
ArrayList envelopes;
ArrayList connections;

Connection last;

int currEdit = 0;


void init(){
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();

  super.init();
}
////////////////////////////////////////////////////

void setup(){

  size(800,870,P2D);
  
  textFont(loadFont("AnonymousPro-11.vlw"),11);

  envelopes = new ArrayList();
  for(int i = 100;i<width;i+=250)
  envelopes.add(new Envelope(i,50));

  connections = new ArrayList();

  editors = new ArrayList();

  editors.add(new Editor("syn"+editors.size(),150,300));
  currEdit=0;

  timeline = new Timeline(8);


  rectMode(CENTER);

  osc = new OscP5(this,12000);
  sc = new NetAddress("127.0.0.1",57120);
}
////////////////////////////////////////////////////

void draw(){
  if(frameCount==5)
    frame.setLocation(0,0);

  background(0);

  for(Object o : editors){
    Editor tmp = (Editor)o;
    tmp.render();
  }

  for(Object o : envelopes){
    Envelope tmp = (Envelope)o;
    tmp.draw();
  }

  for(Object o : connections){
    Connection tmp = (Connection)o;
    tmp.draw();
  }



  timeline.render();
}


////////////////////////////////////////////////////


void msg(String obj,String key,float val){
  osc.send("/oo",new Object[] {obj,"set",key,val},sc);
}

void msg(Object [] data){
  osc.send("/oo",data,sc);
}

void freeAll(){
  osc.send("/oo_i",new Object[]{"s.freeAll;"},sc);
}

void stop(){
  saveProject("default.txt");
  freeAll(); 
  super.stop();
}

/*
   class Boid{
   PVector pos,acc,vel;
   String ctl;
   ArrayList history;
   int rew =0;
   float speed = 10.0;

   Boid(String _ctl){
   ctl = _ctl;
   pos = new PVector(width/2,height/2);
   acc  =new PVector(0,0);
   vel = new PVector(0,0);
   history=new ArrayList();
   }

   void draw(){
   move(); 
   fill(0);
   noStroke();
   rect(pos.x,pos.y,5,5);

   rew+=speed;
   rew=rew%history.size();
   PVector tmp = (PVector)history.get(rew);
   rect(tmp.x,tmp.y,3,3);

   msg(ctl,"phase",map(tmp.x,0,width,-PI,PI));
   msg(ctl,"amp",map(tmp.y,0,height,1,0.01));

   beginShape();
   stroke(0);
   noFill();
   for(int i = 0;i<history.size();i++){
   PVector curr = (PVector)history.get(i);
   vertex(curr.x,curr.y);
   }
   endShape();

   }

   void move(){
   acc.mult(0.9);
   vel.mult(0.9);
   pos.add(vel);
   vel.add(acc);
   acc.add(new PVector(random(-0.1,0.1),random(-0.1,0.1)));
   pos.x=constrain(pos.x,1,width);
   pos.y=constrain(pos.y,1,height);

   history.add(new PVector(pos.x,pos.y));
   if(history.size()>1000)
   history.remove(0);
   }

   }
 */


