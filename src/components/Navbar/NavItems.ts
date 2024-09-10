export interface NavItem {
  id: number;
  title: string;
  path: string;
  subMenu?: NavItem[];
}

export const navItems: NavItem[] = [
  {
    id: 1,
    title: "Sobre",
    path: "/",
    subMenu: [
      {
        id: 1,
        title: "Quem Somos",
        path: "/WhoWeAre",
      },
      {
        id: 2,
        title: "Nossa História",
        path: "/OurHistory",
      },
      {
        id: 3,
        title: "Equipe",
        path: "/Team",
      },
      {
        id: 4,
        title: "Parceiros",
        path: "/Partners",
      },
    ],
  },
  {
    id: 2,
    title: "História",
    path: "/history",
  },
  {
    id: 3,
    title: "Geografia",
    path: "/geography",
  },
];
