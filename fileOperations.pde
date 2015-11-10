


void saveProject(String _filename){

  String saveText = "";

  for(Object e:editors){
    Editor tmp = (Editor)e;
    saveText += "@text "+tmp.name+"\n";
    for(int i = 0 ; i < tmp.pre.size();i++){
      String t = (String)tmp.pre.get(i);
      saveText += t+"\n";
    }

    for(int i = 0 ; i < tmp.lines.size();i++){
      String t = (String)tmp.lines.get(i);
      saveText += t+"\n";
    }

    for(int i = 0 ; i < tmp.post.size();i++){
      String t = (String)tmp.pre.get(i);
      saveText += t+"\n";
    }
  }

  for(Object e:envelopes){
    Envelope tmp = (Envelope)e;
    saveText += "@connections "+envelopes.indexOf(tmp)+"\n";
    for(int i = 0 ; i < tmp.connections.size();i++){
      Connection c = (Connection)tmp.connections.get(i);
      if(c.done)
      saveText += envelopes.indexOf(c.env)+" "+editors.indexOf(c.ed)+" "+c.field;
    }
  }

  /**
  TODO:
  saving envelope values?
  */

  String complete[] = splitTokens(saveText,"\n");
  saveStrings(_filename,complete);

}
