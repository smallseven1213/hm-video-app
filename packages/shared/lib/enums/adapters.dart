enum Adapters {
  video, //1
  tags, //2
  videoDetail, //3
  actor, //4
}

// convert enum to int
int adapterId(Adapters adapter) => adapter.index + 1;
