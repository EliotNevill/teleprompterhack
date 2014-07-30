package Speech.Assist;

import android.app.Activity;
import android.os.Bundle;
import java.util.Locale;
import java.util.ArrayList;
import android.speech.tts.TextToSpeech;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.speech.RecognizerIntent;
import android.view.Menu;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;

public class speechassist extends Activity implements
TextToSpeech.OnInitListener {
    /** Called when the activity is first created. */
    private TextToSpeech tts;
    private Button btnListen;
    private EditText txtText;
 
    protected static final int RESULT_SPEECH = 1;
    
    private Button btnSpeak;
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
 
        tts = new TextToSpeech(this, this);
        btnListen = (Button) findViewById(R.id.btnListen);
        txtText = (EditText) findViewById(R.id.txtText);
 
        // button on click event
        btnListen.setOnClickListener(new View.OnClickListener() {
 
            @Override
            public void onClick(View arg0) {
                speakOut();
            }
 
        });
        
        btnSpeak = (Button) findViewById(R.id.btnSpeak);
        
        btnSpeak.setOnClickListener(new View.OnClickListener() {
 
            @Override
            public void onClick(View v) {
 
                Intent intent = new Intent(
                        RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
 
                intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, "en-US");
 
                try {
                    startActivityForResult(intent, RESULT_SPEECH);
                    txtText.setText("");
                } catch (ActivityNotFoundException a) {
                    Toast t = Toast.makeText(getApplicationContext(),
                            "Opps! Your device doesn't support Speech to Text",
                            Toast.LENGTH_SHORT);
                    t.show();
                }
            	}
            });
    }
 
//       public boolean onCreateOptionsMenu(Menu menu) {
//            getMenuInflater().inflate(R.menu.activity_main, menu);
//            return true;
//        }
     
        @Override
        protected void onActivityResult(int requestCode, int resultCode, Intent data) {
            super.onActivityResult(requestCode, resultCode, data);
     
            switch (requestCode) {
            case RESULT_SPEECH: {
                if (resultCode == RESULT_OK && null != data) {
     
                    ArrayList<String> text = data
                            .getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS);
     
                    txtText.setText(text.get(0));
                }
                break;
            }
     
            }
        }
        
    @Override
    public void onDestroy() {
        // Don't forget to shutdown tts!
        if (tts != null) {
            tts.stop();
            tts.shutdown();
        }
        super.onDestroy();
    }
 
    @Override
    public void onInit(int status) {
 
        if (status == TextToSpeech.SUCCESS) {
 
            int result = tts.setLanguage(Locale.US);
 
            if (result == TextToSpeech.LANG_MISSING_DATA
                    || result == TextToSpeech.LANG_NOT_SUPPORTED) {
                Log.e("TTS", "This Language is not supported");
            } else {
                btnListen.setEnabled(true);
                speakOut();
            }
 
        } else {
            Log.e("TTS", "Initilization Failed!");
        }
 
    }
 
    private void speakOut() {
 
        String text = txtText.getText().toString();
 
        tts.speak(text, TextToSpeech.QUEUE_FLUSH, null);
    }
}