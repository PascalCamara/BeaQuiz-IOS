package com.example.pascalcamara.beaquiz;

import android.os.Bundle;
import android.support.v4.content.res.ResourcesCompat;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;


/**
 * Created by pascalcamara on 03/12/2016.
 */

public class CreatePseudo  extends AppCompatActivity{

    ProgressBar pseudoProgressBar;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.create_pseudo);

        this.pseudoProgressBar = (ProgressBar) findViewById(R.id.pseudoProgressBar);

        // set statusbar color
        Window window = getWindow();
        window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
        window.setStatusBarColor( ResourcesCompat.getColor(getResources(), R.color.colorPrimaryDark, null));

        Button createPseudo = (Button) findViewById(R.id.createPseudoBtn);
        createPseudo.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View view) {
                // start progress
                pseudoProgressBar.setVisibility(View.VISIBLE);
                // get createpseudotext
                EditText pseudoText = (EditText) findViewById(R.id.pseudoText);

                // send http request to verrify if exist
                pseudoExist(String.valueOf(pseudoText.getText()));

            }
        });
    }

protected void pseudoExist (final String pseudo) {
/*    URL url = new URL("http://www.android.com/");
    HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
    try {
        InputStream in = new BufferedInputStream(urlConnection.getInputStream());
        readStream(in);
    } finally {
        urlConnection.disconnect();
    } */

    Thread t = new Thread(new Runnable() {
        @Override
        public void run() {
            String urlText = "http://www.pascalcamara.fr/API/player/exist/" + pseudo;
            try {
                URL url = new URL(urlText);
                HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
                InputStream in = new BufferedInputStream(urlConnection.getInputStream());
                in.read();

            } catch (MalformedURLException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    });

    t.start();
}



}
