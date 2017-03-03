using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;
namespace ImageQuantization
{

    public partial class MainForm : Form
    {
        int a = 0;
        int b = 0;
        public MainForm()
        {
            InitializeComponent();
            notifyIcon1.Icon = this.Icon;
            notifyIcon1.ShowBalloonTip(10, "Assembly Project", "Call DumpRegs Team", ToolTipIcon.Info);
        }

        RGBPixel[,] ImageMatrix;

        private void btnOpen_Click(object sender, EventArgs e)
        {
            try
            {
                OpenFileDialog openFileDialog1 = new OpenFileDialog();
                openFileDialog1.Filter = "JPEG Files (*.jpeg)|*.jpeg|PNG Files (*.png)|*.png|JPG Files (*.jpg)|*.jpg|GIF Files (*.gif)|*.gif";
                if (openFileDialog1.ShowDialog() == DialogResult.OK)
                {
                    string OpenedFilePath = openFileDialog1.FileName;
                    ImageMatrix = ImageOperations.OpenImage(OpenedFilePath);
                    ImageOperations.DisplayImage(ImageMatrix, pictureBox1);
                }
                txtWidth.Text = ImageOperations.GetWidth(ImageMatrix).ToString();
                txtHeight.Text = ImageOperations.GetHeight(ImageMatrix).ToString();
                button1.Enabled = true;
            }
            catch
            {
               DialogResult d1= MessageBox.Show("Please Select Photo","Error",MessageBoxButtons.OK,MessageBoxIcon.Warning);
            }
        }



        private void button1_Click(object sender, EventArgs e)
        {
            if (pictureBox1.Image != null)
            {
                label4.Visible = false;
                
                SaveFileDialog openFileDialog1 = new SaveFileDialog();
                openFileDialog1.Filter = "txt files (*.txt)|*.txt|All files (*.*)|*.*";
                if (openFileDialog1.ShowDialog() == DialogResult.OK)
                {
                    string OpenedFilePath = openFileDialog1.FileName;
                    

                    int Height = ImageMatrix.GetLength(0);
                    int Width = ImageMatrix.GetLength(1);
                    FileStream fw = new FileStream(OpenedFilePath, FileMode.Append);
                    StreamWriter sw = new StreamWriter(fw);
                    sw.WriteLine(Height);
                    sw.WriteLine(Width);
                    for (int i = 0; i < Height; i++)
                    {
                        for (int j = 0; j < Width; j++)
                        {
                            sw.WriteLine(ImageMatrix[i, j].red);
                            sw.WriteLine(ImageMatrix[i, j].green);
                            sw.WriteLine(ImageMatrix[i, j].blue);
                        }


                    }
                    sw.Write("%");
                    sw.Close();



                }

                this.timer1.Start();

            }
            else
            {
                MessageBox.Show("Please Select Photo");
            }

        }


        private void pictureBox1_Click(object sender, EventArgs e)
        {
        }

        private void closeToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void menuStrip1_ItemClicked(object sender, ToolStripItemClickedEventArgs e)
        {

        }

        private void MainForm_Load(object sender, EventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            try
            {
                OpenFileDialog openFileDialog1 = new OpenFileDialog();
                openFileDialog1.Filter = "txt files (*.txt)|*.txt|All files (*.*)|*.*";
                if (openFileDialog1.ShowDialog() == DialogResult.OK)
                {
                    string OpenedFilePath = openFileDialog1.FileName;


                    FileStream fw = new FileStream(OpenedFilePath, FileMode.Open);
                    StreamReader sw = new StreamReader(fw);
                    int height = int.Parse(sw.ReadLine());
                    int width = int.Parse(sw.ReadLine());
                    txtWidth.Text = width.ToString();
                    txtHeight.Text = height.ToString();
                    ImageMatrix = new RGBPixel[height, width];


                    for (int i = 0; i < height; i++)
                    {
                        for (int j = 0; j < width; j++)
                        {
                            if (sw.Peek() != -1)
                            {
                                ImageMatrix[i, j].red = byte.Parse(sw.ReadLine());
                                ImageMatrix[i, j].green = byte.Parse(sw.ReadLine());
                                ImageMatrix[i, j].blue = byte.Parse(sw.ReadLine());
                            }
                        }


                    }

                    sw.Close();
                    ImageOperations.DisplayImage(ImageMatrix, pictureBox1);
                    


                }
            }
            catch
            {
                DialogResult d1 = MessageBox.Show("Please Select Text", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }

        }

        private void closeToolStripMenuItem_Click_1(object sender, EventArgs e)
        {
            
            this.Close();
        }

        private void closeToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void aboutToolStripMenuItem_Click(object sender, EventArgs e)
        {

            MessageBox.Show("Devolped By:\nHassan Sayed\nHazem Marawan\nAhmed Amin\nSaher AbdelAziz\nGamal Ashraf\nAssembly Project 2016-2017", "About", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void button3_Click(object sender, EventArgs e)
        {
            if (pictureBox1.Image != null)
            {
                label4.Visible = false;
               
                SaveFileDialog openFileDialog1 = new SaveFileDialog();
                openFileDialog1.Filter = "JPEG Files (*.jpeg)|*.jpeg|PNG Files (*.png)|*.png|JPG Files (*.jpg)|*.jpg|GIF Files (*.gif)|*.gif";
                if (openFileDialog1.ShowDialog() == DialogResult.OK)
                {
                    string OpenedFilePath = openFileDialog1.FileName;
                    OpenedFilePath = OpenedFilePath + ".jpeg";
                    pictureBox1.Image.Save(OpenedFilePath);

                }
                this.timer1.Stop();
                this.timer1.Start();
            }
            else
            {
                MessageBox.Show("Please Select Photo");
            }

        }

        private void button4_Click(object sender, EventArgs e)
        {
            button5.Visible = true;
            button3.Visible = false;
            button1.Visible = false;
            button2.Visible = false;
           
            btnOpen.Visible = false;
            
            txtWidth.Visible = false;
            txtHeight.Visible = false;
            pictureBox1.Visible = false;
            
          
            label6.Visible = false;
           
            label5.Visible = false;
            label4.Visible = false;
            
            label2.Text = "Thanks for using our Software";
          //  label2.Visible = true;
            label3.Visible = true;
           // label3.Text = "Assembly Project 2016";
            pictureBox2.Visible = true;
            a++;
            if (a == 2)
            {
                this.Close();
            }

        }

        private void timer1_Tick(object sender, EventArgs e)
        {
           
          

        }

        private void pictureBox1_Click_1(object sender, EventArgs e)
        {

        }

        private void imageToolStripMenuItem_Click(object sender, EventArgs e)
        {
            try
            {
                OpenFileDialog openFileDialog1 = new OpenFileDialog();
                if (openFileDialog1.ShowDialog() == DialogResult.OK)
                {
                    string OpenedFilePath = openFileDialog1.FileName;
                    ImageMatrix = ImageOperations.OpenImage(OpenedFilePath);
                    ImageOperations.DisplayImage(ImageMatrix, pictureBox1);
                }
                txtWidth.Text = ImageOperations.GetWidth(ImageMatrix).ToString();
                txtHeight.Text = ImageOperations.GetHeight(ImageMatrix).ToString();
            }
            catch
            {
                MessageBox.Show("Please Select Photo");
            }
            
        }

        private void textToolStripMenuItem_Click(object sender, EventArgs e)
        {
            try
            {
                OpenFileDialog openFileDialog1 = new OpenFileDialog();
                if (openFileDialog1.ShowDialog() == DialogResult.OK)
                {
                    string OpenedFilePath = openFileDialog1.FileName;


                    FileStream fw = new FileStream(OpenedFilePath, FileMode.Open);
                    StreamReader sw = new StreamReader(fw);
                    int height = int.Parse(sw.ReadLine());
                    int width = int.Parse(sw.ReadLine());
                    ImageMatrix = new RGBPixel[height, width];


                    for (int i = 0; i < height; i++)
                    {
                        for (int j = 0; j < width; j++)
                        {
                            if (sw.Peek() != -1)
                            {
                                ImageMatrix[i, j].red = byte.Parse(sw.ReadLine());
                                ImageMatrix[i, j].green = byte.Parse(sw.ReadLine());
                                ImageMatrix[i, j].blue = byte.Parse(sw.ReadLine());
                            }
                        }


                    }

                    sw.Close();
                    ImageOperations.DisplayImage(ImageMatrix, pictureBox1);
                  


                }
            }
            catch
            {
                MessageBox.Show("Please Select Text File ");
            }
        }

        private void imageToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            if (pictureBox1.Image != null)
            {
                SaveFileDialog openFileDialog1 = new SaveFileDialog();
                if (openFileDialog1.ShowDialog() == DialogResult.OK)
                {
                    string OpenedFilePath = openFileDialog1.FileName;
                    OpenedFilePath = OpenedFilePath + ".jpeg";
                    pictureBox1.Image.Save(OpenedFilePath);

                }
            }
            else
            {
                MessageBox.Show("Please Select Photo");
            }
        }

        private void textToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            if (pictureBox1.Image != null)
            {
                SaveFileDialog openFileDialog1 = new SaveFileDialog();
                if (openFileDialog1.ShowDialog() == DialogResult.OK)
                {
                    string OpenedFilePath = openFileDialog1.FileName;
                    OpenedFilePath = OpenedFilePath + ".txt";

                    int Height = ImageMatrix.GetLength(0);
                    int Width = ImageMatrix.GetLength(1);
                    FileStream fw = new FileStream(OpenedFilePath, FileMode.Append);
                    StreamWriter sw = new StreamWriter(fw);
                    sw.WriteLine(Height);
                    sw.WriteLine(Width);
                    for (int i = 0; i < Height; i++)
                    {
                        for (int j = 0; j < Width; j++)
                        {
                            sw.WriteLine(ImageMatrix[i, j].red);
                            sw.WriteLine(ImageMatrix[i, j].green);
                            sw.WriteLine(ImageMatrix[i, j].blue);
                        }


                    }

                    sw.Close();



                }



            }
            else
            {
                MessageBox.Show("Please Select Photo");
            }

        }

        private void button5_Click(object sender, EventArgs e)
        {

        }

        private void pictureBox1_Click_2(object sender, EventArgs e)
        {

        }

        private void button5_Click_1(object sender, EventArgs e)
        {
            this.Close();
        }
    }



}
