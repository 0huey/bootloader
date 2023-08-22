void main (void) {
	char* video_mem = (char*)0xb8000;

	const char* msg = "running da kernel";

	for (; *msg != '\0'; msg++, video_mem += 2) {
		*video_mem = *msg;
	}
}
