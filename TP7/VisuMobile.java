import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Color;
import java.awt.Button;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JList;
import javax.swing.JLabel;
import javax.swing.JComboBox;
import javax.swing.BoxLayout;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JOptionPane;

public class VisuMobile implements ActionListener {
	// Quelques constantes ...
	// ... pour les longeurs
	private final int LONG_MAX = 20;
	// ... pour les poids
	private final int POIDS_MAX = 20;
	// ... affichage 
	private final int MARGE = 20;
	private final int PETIT = 15;
	private final int LARGE_FEN = Math.max(800, 3 * LONG_MAX * PETIT + 2 * MARGE);
	private final float COEF_MASSE = 10.0f;
	// ... les actions
	private static final String COMM_AUTRE = "autre";
	private static final String COMM_LONG = "longueur";
	// ... les couleurs
	private static final Color COUL_OK = new Color(0,200,20);
	private static final Color COUL_NON_OK =  Color.RED;

	//attributs
	private JFrame f;
	private JPanel conteneur;
	private Button go_Mobile;
	private Button go_Autre;

	private JComboBox L1;
	private JComboBox L2;
	private JComboBox L3;
	private JComboBox L4;

	// notre cher mobile ("Allo ?")
	private Mobile mob;

	private Color couleur;

	public VisuMobile() {
		f = new JFrame("TP Contraintes : Mobile");
		f.setLayout(new BorderLayout());
		f.setSize(new Dimension(LARGE_FEN, 400));
		f.setResizable(false);
		f.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

		f.setLayout(new BorderLayout());

		go_Mobile = new Button("Go");
		go_Mobile.addActionListener(this);

		go_Autre = new Button("Autre solution ?");
		go_Autre.addActionListener(this);
		go_Autre.setActionCommand(COMM_AUTRE);

		JPanel choix = new JPanel();
		choix.setLayout(new BoxLayout(choix, BoxLayout.X_AXIS));
		choix.add(go_Mobile);
		choix.add(go_Autre);
		f.add(choix, BorderLayout.NORTH);

		choix = new JPanel();
		choix.setLayout(new BoxLayout(choix, BoxLayout.X_AXIS));

		L1 = new JComboBox();
		L1.setMinimumSize(new Dimension(75, 30));

		L2 = new JComboBox();
		L2.setMinimumSize(new Dimension(75, 30));

		L3 = new JComboBox();
		L3.setMinimumSize(new Dimension(75, 30));

		L4 = new JComboBox();
		L4.setMinimumSize(new Dimension(75, 30));

		for (int i=1; i<=LONG_MAX; i++)	{
			L1.addItem(new Integer(i));
			L2.addItem(new Integer(i));
			L3.addItem(new Integer(i));
			L4.addItem(new Integer(i));
		}

		L1.setActionCommand(COMM_LONG);
		L1.addActionListener(this);
		L2.setActionCommand(COMM_LONG);
		L2.addActionListener(this);
		L3.setActionCommand(COMM_LONG);
		L3.addActionListener(this);
		L4.setActionCommand(COMM_LONG);
		L4.addActionListener(this);

		choix.add(new JLabel(" L1="));
		choix.add(L1);
		choix.add(new JLabel(" L2="));
		choix.add(L2);
		choix.add(new JLabel(" L3="));
		choix.add(L3);
		choix.add(new JLabel(" L4="));
		choix.add(L4);

		f.add(choix, BorderLayout.SOUTH);

		// on commence a le creer maintenant pour qu'il existe lors de l'affichage....
		createMobile();

		couleur = COUL_OK;

		conteneur = new JPanel() {
			public void paintComponent(Graphics g) {
				//g.clearRect(0, 0, LARGE_FEN, 200);
				super.paintComponent(g);
				g.setColor(couleur);
				int milieu = LONG_MAX * PETIT + MARGE; //LARGE_FEN / 2 ;
				g.fillRoundRect(milieu - PETIT, 0, 2 * PETIT, PETIT, 5,5);
				g.drawLine(milieu, PETIT, milieu, 2 * PETIT);
				// 1er etage
				int xg = milieu - mob.getL1() * PETIT;
				int xd = milieu + mob.getL2() * PETIT;
				g.drawLine(xg, 2 * PETIT, xd, 2 * PETIT);
				g.drawLine(xg, 2 * PETIT, xg, 4 * PETIT);
				g.drawLine(xd, 2 * PETIT, xd, 3 * PETIT);

				// 2nd etage
				int xg2 = xd - mob.getL3() * PETIT;
				int xd2 = xd + mob.getL4() * PETIT;
				g.drawLine(xg2, 3 * PETIT, xd2, 3 * PETIT);
				g.drawLine(xg2, 3 * PETIT, xg2, 4 * PETIT);
				g.drawLine(xd2, 3 * PETIT, xd2, 4 * PETIT);
				if(mob.estEquilibre()) {
					g.setColor(Color.BLACK);
					// masses
					int tailM1 = (int)(Math.sqrt(mob.getM1()) * COEF_MASSE);
					int tailM2 = (int)(Math.sqrt(mob.getM2()) * COEF_MASSE);
					int tailM3 = (int)(Math.sqrt(mob.getM3()) * COEF_MASSE);

					g.fillOval(xg - tailM1 / 2, 4 * PETIT, tailM1, tailM1);
					g.fillOval(xg2 - tailM2 / 2, 4 * PETIT, tailM2, tailM2);
					g.fillOval(xd2 - tailM3 / 2, 4 * PETIT, tailM3, tailM3);

					g.drawString(new Integer(mob.getM1()).toString(), xg, 5 * PETIT + tailM1);
					g.drawString(new Integer(mob.getM2()).toString(), xg2, 5 * PETIT + tailM2);
					g.drawString(new Integer(mob.getM3()).toString(), xd2, 5 * PETIT + tailM3);
				} else {
					g.drawString("Pas encore resolu !", milieu - 20, 5 * PETIT);
				}
			}
		};

		f.add(conteneur, BorderLayout.CENTER);
		f.setVisible(true);
	}

	private void createMobile() {
		mob = new Mobile(((Integer)L1.getSelectedItem()).intValue(),
						((Integer)L2.getSelectedItem()).intValue(),
						((Integer)L3.getSelectedItem()).intValue(),
						((Integer)L4.getSelectedItem()).intValue(),
						POIDS_MAX);
	}

	public void actionPerformed(ActionEvent e) {
		if (COMM_AUTRE.equals(e.getActionCommand())) {
			if (!mob.autreSolutionMasse()) {
				JOptionPane.showMessageDialog(f, "Pas d'autres solutions !");
			}
		} else if (COMM_LONG.equals(e.getActionCommand())) {
			// on cree le nouveau mobile
			createMobile();
			// on verifie l'encombrement
			if (!mob.longueursCoherentes()) {
				JOptionPane.showMessageDialog(f, "Encombrement non coherent !");
				go_Mobile.setEnabled(false);
				go_Autre.setEnabled(false);
				couleur = COUL_NON_OK;
			} else {
				go_Mobile.setEnabled(true);
				go_Autre.setEnabled(true);
				couleur = COUL_OK;
			}
		} else {
			// puis l'equilibre
			mob.equilibre();
		}
		System.out.println(mob);
		conteneur.repaint();
	}

	public static void main(String[] args) {
		VisuMobile fen = new VisuMobile();
		//fen.show();
	}
}
